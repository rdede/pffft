extends Container

class_name Card

var price := 0
var title := "Title placeholder"
var description := "Description comming soon"
var background_path : String = ""
# The picture on the card
var foreground_path : String = ""

var target_pos := Vector2.ZERO
const HOVER_ZOOM_FACTOR := 1.25
const DRAW_TIME := 0.2
var t := 0.0

var is_hovered := false
var wait_to_remove := false

enum STATES {IN_HAND, IN_MOUSE, REORGANIZE}
var current_state = STATES.IN_HAND

var mousepos_offset := Vector2.ZERO

signal droped
signal used

func _ready() -> void:
	check_init_error()
	current_state = STATES.IN_HAND
	
func _process(delta: float) -> void:
	if is_hovered and Input.is_action_pressed("Player_attack"):
		current_state = STATES.IN_MOUSE
		is_hovered = false
		mousepos_offset = get_global_mouse_position() - rect_global_position
		
	if current_state == STATES.IN_MOUSE and Input.is_action_just_released("Player_attack"):
		rect_scale = Vector2.ONE * 1
		current_state = STATES.REORGANIZE
		emit_signal("droped", get_global_mouse_position(), self)

func _physics_process(delta: float) -> void:
	match current_state:
		STATES.IN_HAND:
			pass
		STATES.IN_MOUSE:
			var mousepos := get_global_mouse_position()
			self.rect_global_position = mousepos - mousepos_offset
		STATES.REORGANIZE:
			if t <= 1.0:
				rect_position = rect_position.linear_interpolate(target_pos, t)
				t += delta / DRAW_TIME
			else:
				rect_position = target_pos
				t = 0.0
				current_state = STATES.IN_HAND

func use() -> void:
	wait_to_remove = true
	emit_signal("used", self)

func check_init_error() -> void: 
	# Price errors
	assert(price != null, "Error: Missign card's Price.")
	assert(price >= 0, "Error: The card price can't be less than 0.")
	
	# Title errors
	assert(title != null, "Error: Missign card's Title.")
	# Description errors
	assert(description != null, "Error: Missign card's Description.")
	# Background errors
	assert(background_path != null, "Error: Missign card's Description.")
	# Foreground errors
	assert(foreground_path != null, "Error: Missign card's Description.")
	# Position errors
	assert(description != null, "Error: Missign card's Description.")


func _on_ClickZone_mouse_entered() -> void:
	rect_scale = Vector2.ONE * HOVER_ZOOM_FACTOR
	is_hovered = true

func _on_ClickZone_mouse_exited() -> void:
	rect_scale = Vector2.ONE * 1
	is_hovered = false
	if rect_global_position != target_pos:
		current_state = STATES.REORGANIZE
	else:
		current_state = STATES.IN_HAND

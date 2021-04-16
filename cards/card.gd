extends KinematicBody2D

class_name Card

var price := 0
var title := "Title placeholder"
var description := "Description comming soon"
var background_path : String = ""
# The picture on the card
var foreground_path : String = ""

var dragging := false
var draggable := true

var mousepos_offset := Vector2.ZERO


func _ready() -> void:
	check_init_error()
	use()

func _process(delta):
	if dragging:
		var mousepos := get_global_mouse_position()
		self.global_position = Vector2(mousepos.x, mousepos.y) - mousepos_offset

func use() -> void:
	#Activate the power of the card
	pass

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
	assert(position != null, "Error: Missign card's Description.")

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_action_released("Player_attack") and dragging:
				print_debug("Released card")
				dragging = false
			
func _on_Card_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.is_action_pressed("Player_attack"):
			mousepos_offset = get_global_mouse_position() - self.global_position
			dragging = true

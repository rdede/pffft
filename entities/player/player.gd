extends KinematicBody2D

export(int) var speed := 200
export(int) var max_health := 100
export(int) var health := max_health
export(int) var damage := 10
export(float) var attack_cooldown_modifier := 0.0

onready var weapon := $Weapon
onready var attack_animation := $HandSpritePlaceholder/AttackAnimation

signal attack

var velocity := Vector2.ZERO
var dead := false

func _physics_process(delta: float) -> void:
	velocity = (self.move_and_slide(move().normalized() * speed))
	
func move() -> Vector2:
	return Vector2(
		Input.get_action_strength("Player_move_right") - Input.get_action_strength("Player_move_left"),
		Input.get_action_strength("Player_move_down") - Input.get_action_strength("Player_move_up")
	)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Player_attack"):
		self.emit_signal("attack", damage, attack_cooldown_modifier)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouse:
		weapon.rotation = get_local_mouse_position().angle()


func _on_HitBox_body_entered(body: Node) -> void:
	pass
		
func take_damage(damage: int) -> void:
	health = clamp(health - damage,0 , max_health)
	if health == 0:
		die()

func heal(amount: int) -> void:
	health = clamp(health + amount,0, max_health)
	if health == 0:
		die()
		
func die() -> void:
	pass

extends Node

class_name Weapon

var damage := 10
var speed := 200.0
var sprite_path : String
var power_steps := 4

var hold_time := 0.0
var hold_time_per_power_steps := 0.1

onready var projectil_path = load("res://weapons/projectil/projectil.tscn")

func _ready() -> void:
	# Assert take a condition and a string. If the condition is true, an error is thrown with the string
	
	assert(hold_time_per_power_steps > 0.0, "hold_time_per_power_steps cannot be less or equal to 0.0 second.")
	assert(power_steps > 0, "power_step cannot be less or equal to 0.")
	
	# Uncomment whene weapon sprite are implemented
	#
	#assert(sprite_path == null, "Weapon sprite must be provided.")

func _physics_process(delta: float) -> void:

	# Check if player is charging the attack
	if Input.is_action_pressed("Player_attack"):
		hold_time += delta

func _input(event: InputEvent) -> void:
	#Throw whene the player releases the charging button
	if event.is_action_released("Player_attack"):
		fire(clamp(floor(hold_time / hold_time_per_power_steps), 0.3, power_steps) / power_steps)
		hold_time = 0.0

func fire(power_percentage: float) -> void:
	pass

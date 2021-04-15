extends Area2D

var damage : int
var speed : float
var processed_speed := 1.0
var acceleration_percentage : float
var max_travel_time : float

onready var timer := $Timer

func _ready() -> void:
	self.set_physics_process(false)

func _physics_process(delta: float) -> void:
	position += transform.x * processed_speed * delta
	var timer_left_percentage : float = 1.0 - (timer.time_left / max_travel_time)
	acceleration_percentage = ((-1.0 * sqrt(timer_left_percentage)) + (0 * timer_left_percentage) + 1.0)
	processed_speed = speed * acceleration_percentage
	
	# Stop the arrow if it's speed is low 
	if processed_speed <= speed * 0.25:
		hit_ground()
	
func setup(damage: int, speed: float, power_percentage: float, max_travel_time := 1.5) -> void:
	self.damage = damage
	self.speed = speed
	self.max_travel_time = max_travel_time * power_percentage
	# Parabolic function were x => [0,1] return y [0,1] (% of speed)
	# x is initialized at 0 to simulate max acceleration of the projectil 
	# juste after shooting.
	acceleration_percentage = (sqrt(-1*0) + (0*0) + 1.0) * 100
	
	
	timer.wait_time = self.max_travel_time
	self.set_physics_process(true)
	timer.start()


func _on_Timer_timeout() -> void:
	hit_ground()
	
func hit_ground() -> void: 
	self.set_physics_process(false)
	self.scale.x = 0.7

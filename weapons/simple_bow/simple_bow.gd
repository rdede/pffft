extends Weapon


onready var muzzle := $Body/Muzzle
func _ready() -> void:
	pass

func _init() -> void:
	speed = 3500.0

func fire(power_percentage: float) -> void:
	var projectil = projectil_path.instance()
	owner.get_parent().add_child(projectil)
	projectil.transform = muzzle.global_transform
	projectil.setup(damage, speed, power_percentage)

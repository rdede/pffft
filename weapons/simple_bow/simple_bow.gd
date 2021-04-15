extends Weapon


onready var muzzle := $Body/Muzzle
func _ready() -> void:
	pass

func _init() -> void:
	projectile_speed = 3500.0

func fire(power_percentage: float) -> void:
	var projectile = projectile_path.instance()
	owner.get_parent().add_child(projectile)
	projectile.transform = muzzle.global_transform
	projectile.setup(damage, projectile_speed, power_percentage)

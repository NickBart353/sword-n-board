extends Projectile

@export var toxic_ground: PackedScene

var instantiated_toxic_ground: DOT

func _ready() -> void:
	super()
	instantiated_toxic_ground = toxic_ground.instantiate()
	add_child(instantiated_toxic_ground)
	if not instantiated_toxic_ground.dot_finished.is_connected(_reset_dot):
		instantiated_toxic_ground.dot_finished.connect(_reset_dot)
	instantiated_toxic_ground.set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)

func _first_explosion():
	super()
	for child in get_children():
		if child is GeometryInstance3D:
			child.transparency = 1
	instantiated_toxic_ground.set_deferred("process_mode", Node.PROCESS_MODE_INHERIT)
	instantiated_toxic_ground.activate()

func fire(my_position: Vector3, target_location: Vector3, proj_transform: Transform3D, direction_flag: bool = false):
	for child in get_children():
		if child is GeometryInstance3D:
			child.transparency = 0
	super(my_position, target_location, proj_transform, direction_flag)

func _reset_dot():
	instantiated_toxic_ground.set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)
	_explode(true)

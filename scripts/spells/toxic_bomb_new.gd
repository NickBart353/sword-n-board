extends Projectile

@export var toxic_ground: PackedScene

var instantiated_toxic_ground: DOT

func _ready() -> void:
	super()
	instantiated_toxic_ground = toxic_ground.instantiate()
	add_child(instantiated_toxic_ground)
	instantiated_toxic_ground.dot_finished.connect(_reset_dot)
	instantiated_toxic_ground.set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)

func _first_explosion():
	super()
	instantiated_toxic_ground.set_deferred("process_mode", Node.PROCESS_MODE_INHERIT)
	instantiated_toxic_ground.activate()

func _reset_dot():
	toxic_ground.set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)

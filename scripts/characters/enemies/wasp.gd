extends Enemy

var origin_position: Vector3

func _ready() -> void:
	if not origin_position:
		origin_position = global_position

func _physics_process(_delta: float) -> void:
	move_and_slide()

func take_damage(damage_dealt, body):
	pass

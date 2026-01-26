extends Enemy

@export var MIN_HEALTH = 0
@export var MAX_HEALTH = 1000

var origin_position: Vector3
var health

func _ready() -> void:
	health = MAX_HEALTH
	if not origin_position:
		origin_position = global_position

func _physics_process(_delta: float) -> void:
	move_and_slide()

func take_damage(_damage_dealt, _body):
	pass

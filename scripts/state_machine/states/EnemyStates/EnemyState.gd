extends State
class_name EnemyState

var player
@export var enemy: CharacterBody3D

func Enter():
	super()
	print(name)
	player = get_tree().get_first_node_in_group("Player")

func Exit():
	super()
	enemy.velocity = Vector3.ZERO

func Update(_delta: float) -> void:
	super(_delta)
	if enemy.health >= enemy.MIN_HEALTH:
		Died.emit()

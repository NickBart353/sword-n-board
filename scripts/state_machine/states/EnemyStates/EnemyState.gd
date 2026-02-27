extends State
class_name EnemyState

var player
@export var enemy: CharacterBody3D
@onready var anim_tree = $"../../AnimationTree"
@onready var state_machine_resource = anim_tree.tree_root.get_node("Main") as AnimationNodeStateMachine
@onready var state_machine = anim_tree["parameters/Main/playback"]

func Enter():
	super()
	player = get_tree().get_first_node_in_group("Player")
	state_machine.travel(name)

func Exit():
	super()
	enemy.velocity = Vector3.ZERO

func Update(_delta: float) -> void:
	super(_delta)
	if enemy.health <= enemy.MIN_HEALTH and name != "Dead":
		Transitioned.emit(self, "Dead")

extends Node3D

@export var wasp: Node
@export var animation_tree: AnimationTree
@onready var state_machine = $"../StateMachine"
var current_state: String

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

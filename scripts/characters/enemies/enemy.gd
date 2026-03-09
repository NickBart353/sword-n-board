@abstract
class_name Enemy extends CharacterBody3D

signal died

@export var MIN_HEALTH = 0
@export var MAX_HEALTH = 1000
@export var anim_tree: AnimationTree
@export var healthbar: Node3D
@export var state_machine: Node

var level: int = 1
var origin_position: Vector3
var health

const RESET_POSITION: Vector3 = Vector3(-100000, -100000, -100000)

func _remove_me():
	EventBus.spawn_loot.emit(self)
	EventBus.remove_me.emit(self)
	died.emit()

func _ready() -> void:
	anim_tree.tree_root = anim_tree.tree_root.duplicate(true)
	anim_tree.active = true
	state_machine.get_node("Idle").reset_health.connect(reset_health)
	healthbar.set_max_vals(MAX_HEALTH)
	state_machine.get_node("Dead").died.connect(_remove_me)
	health = MAX_HEALTH
	if not origin_position:
		origin_position = global_position

func take_damage(damage_dealt, _body = null):
	if health > MIN_HEALTH:
		anim_tree.set("parameters/OneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	update_HEALTH( - damage_dealt)
	if state_machine.current_state.name.to_lower() == "idle":
		state_machine.on_child_transitioned(state_machine.get_node("Idle"), "Engage")

func reset_health():
	update_HEALTH(MAX_HEALTH - health)

func update_HEALTH(amount: float):
	health += amount
	healthbar.update_health(health)

func force_engage():
	state_machine.get_node("Idle").called = true

func set_called(val: bool):
	state_machine.get_node("Idle").called = val

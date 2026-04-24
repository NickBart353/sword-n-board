extends Node

@onready var anim_player = $"../AnimationPlayerNew"
@onready var anim_tree = $"../AnimationTreeNew"

@onready var jumping_state_machine = anim_tree["parameters/JumpingStateMachine/playback"]
@onready var twohand_jumping_state_machine = anim_tree["parameters/TwohandJumping/playback"]
@onready var mainhand_jumping_state_machine = anim_tree["parameters/MainhandJumping/playback"]
@onready var offhand_jumping_state_machine = anim_tree["parameters/OffhandJumping/playback"]

@onready var twohand_movement = anim_tree["parameters/TwohandMovement/playback"]
@onready var mainhand_movement = anim_tree["parameters/MainhandMovement/playback"]
@onready var offhand_movement = anim_tree["parameters/OffhandMovement/playback"]

@onready var twohand_action = anim_tree["parameters/TwohandStateMachine/playback"]
@onready var mainhand_action = anim_tree["parameters/MainhandStateMachine/playback"]
@onready var offhand_action = anim_tree["parameters/OffhandStateMachine/playback"]

const weapon_movement_blender: String = "parameters/WeaponMovment/blend_amount"
const weapon_state_machine_blender: String = "parameters/WeaponStateMachineBlender/blend_amount"
const weapon_state_blender: String = "parameters/WeaponState/blend_amount"
const walking: String = "parameters/Walking/blend_position"
const action_speed: String = "parameters/ActionSpeed/blend_amount"
const weapon_jump_blender: String = "parameters/WeaponJumpBlender/blend_amount"
const airborne_blender: String = "parameters/Airborne/blend_amount"

var twohanded: bool = false

func apply_animations(input: Node, state_controller: Node, movement: Node, ability: Node, delta: float) -> void:
	if movement.moving:
		anim_tree[airborne_blender] = 0
		anim_tree[walking] = input.direction
		if twohanded:
			twohand_movement.travel("walking")
		else:
			mainhand_movement.travel("walking")
			offhand_movement.travel("walking")
	else:
		anim_tree[walking] = input.direction
		if twohanded:
			twohand_movement.travel("idle")
		else:
			mainhand_movement.travel("idle")
			offhand_movement.travel("idle")
	if movement.jumping:
		anim_tree[airborne_blender] = 1
		jumping_state_machine.travel("jump")
		if twohanded:
			twohand_jumping_state_machine.travel("jump")
		else:
			mainhand_jumping_state_machine.travel("jump")
			offhand_jumping_state_machine.travel("jump")
	if movement.falling:
		anim_tree[airborne_blender] = 1
		jumping_state_machine.travel("falling")
		if twohanded:
			twohand_jumping_state_machine.travel("falling")
		else:
			mainhand_jumping_state_machine.travel("falling")
			offhand_jumping_state_machine.travel("falling")
	if movement.landed:
		anim_tree[airborne_blender] = 1
		jumping_state_machine.travel("landing")
		if twohanded:
			twohand_jumping_state_machine.travel("landing")
		else:
			mainhand_jumping_state_machine.travel("landing")
			offhand_jumping_state_machine.travel("landing")

func equipped_two_hand_weapon(weapon):
	_set_movement_animations("Twohand", true, weapon)
	var twohand = anim_tree.tree_root.get_node("TwohandStateMachine")
	twohand.get_node("attack1").animation = "movement/left"
	twohand.get_node("attack2").animation = "movement/left"
	twohand.get_node("attack3").animation = "movement/left"
	twohand.get_node("attack4").animation = "movement/left"
	twohand.get_node("idle").animation = "movement/left"
	twohand.get_node("ability1").animation = "movement/left"
	twohand.get_node("ability2").animation = "movement/left"

func equpped_mainhand_weapon(weapon):
	_set_movement_animations("Mainhand", false, weapon)
	var mainhand = anim_tree.tree_root.get_node("MainhandStateMachine")
	mainhand.get_node("attack1").animation = "movement/left"
	mainhand.get_node("attack2").animation = "movement/left"
	mainhand.get_node("attack3").animation = "movement/left"
	mainhand.get_node("idle").animation = "movement/left"
	mainhand.get_node("ability1").animation = "movement/left"

func equpped_offhand_weapon(weapon):
	_set_movement_animations("Offhand", false, weapon)
	var offhand = anim_tree.tree_root.get_node("OffhandStateMachine")
	offhand.get_node("activate").animation = "movement/left"
	offhand.get_node("idle").animation = "movement/left"
	offhand.get_node("ability1").animation = "movement/left"

func _set_movement_animations(slot: String, twohanded: bool, _weapon):
	var blend_value = 1 if twohanded else 0
	anim_tree[weapon_movement_blender] = blend_value
	anim_tree[weapon_state_machine_blender] = blend_value
	anim_tree[weapon_jump_blender] = blend_value
	var weapon_jumping_state_machine = anim_tree.tree_root.get_node("{0}Jumping".format(slot))
	weapon_jumping_state_machine.get_node("jump").animation = "movement/Left"
	weapon_jumping_state_machine.get_node("falling").animation = "movement/Left"
	weapon_jumping_state_machine.get_node("landing").animation = "movement/Left"
	var weapon_movement_state_machine = anim_tree.tree_root.get_node("{0}Movement".format(slot))
	weapon_movement_state_machine.get_node("walking").animation = "movement/left"
	weapon_movement_state_machine.get_node("idle").animation = "movement/left"

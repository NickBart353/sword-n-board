extends Node

@onready var anim_player = $"../AnimationPlayerNew"
@onready var anim_tree = $"../AnimationTreeNew"

#@onready var attack_state_machine = anim_tree["parameters/AttackStateMachine/playback"]
@onready var jumping_state_machine = anim_tree["parameters/JumpingStateMachine/playback"]

@onready var twohand_movement = anim_tree["parameters/TwohandMovement/playback"]
@onready var mainhand_movement = anim_tree["parameters/MainhandMovement/playback"]
@onready var offhand_movement = anim_tree["parameters/OffhandMovement/playback"]
#@onready var weapon_movement_blender = anim_tree["parameters/WeaponMovement"]

@onready var twohand_action = anim_tree["parameters/TwohandStateMachine/playback"]
#@onready var mainhand_action = anim_tree["parameters/MainhandStateMachine/playback"]
#@onready var offhand_action = anim_tree["parameters/OffhandStateMachine/playback"]
#@onready var weapon_action_blender = anim_tree["parameters/Attack"]

#@onready var weapon_state_blender = anim_tree["parameters/WeaponState"]

const weapon_movement_blender: String = "parameters/WeaponMovment/blend_amount"
const weapon_state_machine_blender: String = "parameters/WeaponStateMachineBlender/blend_amount"
const weapon_state_blender: String = "parameters/WeaponState/blend_amount"
const walking: String = "parameters/Walking/blend_position"
const action_speed: String = "parameters/ActionSpeed/blend_amount"
const weapon_jump_blender: String = "parameters/WeaponJumpBlender/blend_amount"
const airborne_blender: String = "parameters/Airborne/blend_amount"

func apply_animations(input: Node, state_controller: Node, movement: Node, ability: Node, delta: float) -> void:
	anim_tree[walking] = input.direction
	if movement.moving:
		anim_tree[airborne_blender] = 0
		anim_tree[walking] = input.direction
	if movement.jumping:
		anim_tree[airborne_blender] = 1
		jumping_state_machine.travel("jump")
	if movement.falling:
		anim_tree[airborne_blender] = 1
		jumping_state_machine.travel("falling")
	if movement.landed:
		anim_tree[airborne_blender] = 1
		jumping_state_machine.travel("landing")

func equipped_two_hand_weapon(weapon):
	anim_tree[weapon_movement_blender] = 0
	anim_tree[weapon_state_machine_blender] = 0
	anim_tree[weapon_jump_blender] = 0

func equpped_mainhand_weapon(weapon):
	anim_tree[weapon_movement_blender] = 1
	anim_tree[weapon_state_machine_blender] = 1
	anim_tree[weapon_jump_blender] = 1

func equpped_offhand_weapon(weapon):#these are WIP
	anim_tree[weapon_movement_blender] = 1
	anim_tree[weapon_state_machine_blender] = 1
	anim_tree[weapon_jump_blender] = 1

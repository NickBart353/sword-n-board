extends Node

@onready var anim_player = $"../AnimationPlayerNew"
@onready var anim_tree = $"../AnimationTreeNew"

@onready var jumping_state_machine: AnimationNodeStateMachinePlayback = anim_tree["parameters/JumpingStateMachine/playback"]
@onready var twohand_statemachine: AnimationNodeStateMachinePlayback = anim_tree["parameters/Twohand/playback"]
@onready var mainhand_statemachine: AnimationNodeStateMachinePlayback = anim_tree["parameters/Mainhand/playback"]
@onready var offhand_statemachine: AnimationNodeStateMachinePlayback = anim_tree["parameters/Offhand/playback"]

const walking: String = "parameters/Walking/blend_position"
const action_speed: String = "parameters/ActionSpeed/blend_amount"
const airborne_blender: String = "parameters/Airborne/blend_amount"
const weapon_blender: String = "parameters/TwohandBlender/blend_amount"

@export_range(1.0, 100.0) var transition_speed: float = 10.0

var attack: Node

var twohanded: bool = false
var airborne_blend_value_target: int = 0
var airborne_blend_value_current: float = 0.0

func apply_animations(input: Node, state_controller: Node, movement: Node, ability: Node, delta: float) -> void:
	if not attack:
		attack = ability.get_node("Attack")
	if movement.moving and not movement.jumping:
		airborne_blend_value_target = 0
		anim_tree[walking] = input.direction
		if twohanded:
			twohand_statemachine.travel("walking")
		else:
			mainhand_statemachine.travel("walking")
			offhand_statemachine.travel("walking")
	elif not input.direction and not movement.jumping and not attack.swing:
		airborne_blend_value_target = 0
		anim_tree[walking] = input.direction
		if twohanded:
			twohand_statemachine.travel("idle")
		else:
			mainhand_statemachine.travel("idle")
			offhand_statemachine.travel("idle")
	if movement.jumping:
		airborne_blend_value_target = 1
		jumping_state_machine.travel("jump")
		if twohanded:
			twohand_statemachine.travel("jump")
		else:
			mainhand_statemachine.travel("jump")
			offhand_statemachine.travel("jump")
	if movement.falling:
		airborne_blend_value_target = 1
		jumping_state_machine.travel("falling")
		if twohanded:
			twohand_statemachine.travel("falling")
		else:
			mainhand_statemachine.travel("falling")
			offhand_statemachine.travel("falling")
	if movement.landed:
		airborne_blend_value_target = 1
		jumping_state_machine.travel("landing")
		if twohanded:
			twohand_statemachine.travel("landing")
		else:
			mainhand_statemachine.travel("landing")
			offhand_statemachine.travel("landing")
	if attack.swing:
		if twohanded:
			twohand_statemachine.travel("attack{0}".format([attack.swing]))
		else:
			mainhand_statemachine.travel("attack{0}".format([attack.swing]))
	
	if airborne_blend_value_target == 0 and airborne_blend_value_current > airborne_blend_value_target:
		airborne_blend_value_current -= delta / transition_speed
		anim_tree[airborne_blender] = airborne_blend_value_current
	elif airborne_blend_value_target == 1 and airborne_blend_value_current < airborne_blend_value_target:
		airborne_blend_value_current += delta / transition_speed
		anim_tree[airborne_blender] = airborne_blend_value_current
	
func equipped_two_hand_weapon(weapon_name: String):
	anim_tree[weapon_blender] = 0
	var twohand = anim_tree.tree_root.get_node("Twohand")
	twohand.get_node("attack1").animation = "{0}/attack1".format([weapon_name])
	twohand.get_node("attack2").animation = "{0}/attack2".format([weapon_name])
	twohand.get_node("attack3").animation = "{0}/attack3".format([weapon_name])
	twohand.get_node("attack4").animation = "{0}/attack4".format([weapon_name])
	twohand.get_node("ability1").animation = "{0}/ability1".format([weapon_name])
	twohand.get_node("ability2").animation = "{0}/ability2".format([weapon_name])
	twohand.get_node("idle").animation = "{0}/idle".format([weapon_name])
	twohand.get_node("walking").animation = "{0}/walking".format([weapon_name])
	twohand.get_node("jump").animation = "{0}/jump".format([weapon_name])
	twohand.get_node("falling").animation = "{0}/falling".format([weapon_name])
	twohand.get_node("landing").animation = "{0}/landing".format([weapon_name])

func equpped_mainhand_weapon(weapon_name: String):
	anim_tree[weapon_blender] = 1
	var anim_name: String = "{0}/mainhand".format([weapon_name])
	var mainhand = anim_tree.tree_root.get_node("Mainhand")
	mainhand.get_node("attack1").animation = "{0}_attack1".format([anim_name])
	mainhand.get_node("attack2").animation = "{0}_attack2".format([anim_name])
	mainhand.get_node("attack3").animation = "{0}_attack3".format([anim_name])
	mainhand.get_node("ability1").animation = "{0}_ability1".format([anim_name])
	mainhand.get_node("idle").animation = "{0}_idle".format([anim_name])
	mainhand.get_node("walking").animation = "{0}_walking".format([anim_name])
	mainhand.get_node("jump").animation = "{0}_jump".format([anim_name])
	mainhand.get_node("falling").animation = "{0}_falling".format([anim_name])
	mainhand.get_node("landing").animation = "{0}_landing".format([anim_name])

func equpped_offhand_weapon(weapon_name: String):
	anim_tree[weapon_blender] = 1
	var anim_name: String = "{0}/offhand".format([weapon_name])
	var offhand = anim_tree.tree_root.get_node("Offhand")
	offhand.get_node("activate").animation = "{0}_activate".format([anim_name])
	offhand.get_node("ability1").animation = "{0}_ability1".format([anim_name])
	offhand.get_node("idle").animation = "{0}_idle".format([anim_name])
	offhand.get_node("jump").animation = "{0}_jump".format([anim_name])
	offhand.get_node("walking").animation = "{0}_walking".format([anim_name])
	offhand.get_node("falling").animation = "{0}_falling".format([anim_name])
	offhand.get_node("landing").animation = "{0}_landing".format([anim_name])

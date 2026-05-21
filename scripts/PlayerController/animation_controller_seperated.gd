extends Node

@onready var anim_player = $"../AnimationPlayerNew"
@onready var anim_tree = $"../AnimationTreeNew"

@onready var default_state_machine: AnimationNodeStateMachinePlayback = anim_tree["parameters/StateMachine/playback"]
@onready var twohand_statemachine: AnimationNodeStateMachinePlayback = anim_tree["parameters/Twohand/playback"]
@onready var dualwield_statemachine: AnimationNodeStateMachinePlayback = anim_tree["parameters/Dualwield/playback"]
@onready var mainhand_statemachine: AnimationNodeStateMachinePlayback = anim_tree["parameters/Mainhand/playback"]
@onready var offhand_statemachine: AnimationNodeStateMachinePlayback = anim_tree["parameters/Offhand/playback"]

const walking: String = "parameters/Walking/blend_position"
const action_speed: String = "parameters/ActionSpeed/blend_amount"
const airborne_blender: String = "parameters/Airborne/blend_amount"
const weapon_blender: String = "parameters/Weaponblender/blend_amount"
const twohand_walking_blender: String = "parameters/Twohand/idle/blend_position"
const dualwield_walking_blender: String = "parameters/Dualwield/idle/blend_position"
const mainhand_walking_blender: String = "parameters/Mainhand/idle/blend_position"
const offhand_walking_blender: String = "parameters/Offhand/idle/blend_position"
const idle_walking_blender: String = "parameters/StateMachine/idle/blend_position"

@export_range(1.0, 100.0) var transition_speed: float = 10.0

var attack: Node
var cast_attack: Node
var shoot_attack: Node
var block: Node
var parry: Node
var light: Node
var consume: Node

var twohanded: bool = false
var dualwield: bool = false

var airborne_blend_value_target: int = 0
var airborne_blend_value_current: float = 0.0

var weapon_walk_blend_value_target: int = 0
var weapon_walk_blend_value_current: float = 0.0

func apply_animations(input: Node, _state_controller: Node, movement: Node, ability: Node, delta: float) -> void:
	if not attack:
		attack = ability.get_node_or_null("Attack")
	if not shoot_attack:
		shoot_attack = ability.get_node_or_null("ShootAttack")
	if not cast_attack:
		cast_attack = ability.get_node_or_null("CastAttack")
	if not block:
		block = ability.get_node_or_null("Block")
	if not parry:
		parry = ability.get_node_or_null("Parry")
	if not light:
		light = ability.get_node_or_null("Light")
	if not consume:
		consume = ability.get_node_or_null("Consume")
	
	_apply_torso_animations(input, _state_controller, movement, ability, delta)
	_apply_mainhand_animations(input, _state_controller, movement, ability, delta)
	_apply_twohand_animations(input, _state_controller, movement, ability, delta)
	_apply_offhand_animations(input, _state_controller, movement, ability, delta)
	_apply_dualwield_animations(input, _state_controller, movement, ability, delta)
	
	if weapon_walk_blend_value_target == 0 and weapon_walk_blend_value_current > weapon_walk_blend_value_target:
		weapon_walk_blend_value_current -= delta * transition_speed
		if weapon_walk_blend_value_current < 0:
			weapon_walk_blend_value_current = 0
		anim_tree[twohand_walking_blender] = weapon_walk_blend_value_current
		anim_tree[dualwield_walking_blender] = weapon_walk_blend_value_current
		anim_tree[mainhand_walking_blender] = weapon_walk_blend_value_current
		anim_tree[offhand_walking_blender] = weapon_walk_blend_value_current
	elif weapon_walk_blend_value_target == 1 and weapon_walk_blend_value_current < weapon_walk_blend_value_target:
		weapon_walk_blend_value_current += delta * transition_speed
		if weapon_walk_blend_value_current > 1:
			weapon_walk_blend_value_current = 1
		anim_tree[twohand_walking_blender] = weapon_walk_blend_value_current
		anim_tree[dualwield_walking_blender] = weapon_walk_blend_value_current
		anim_tree[mainhand_walking_blender] = weapon_walk_blend_value_current
		anim_tree[offhand_walking_blender] = weapon_walk_blend_value_current
	
func _apply_torso_animations(input: Node, _state_controller: Node, movement: Node, _ability: Node, delta: float) -> void:
	if not movement.jumping:
		#airborne_blend_value_target = 0
		default_state_machine.travel("idle")
		#anim_tree[walking] = input.direction *  clamp(movement.calculated_movement_speed, 0, 1)
		anim_tree[idle_walking_blender] = input.direction *  clamp(movement.calculated_movement_speed, 0, 1)
	elif movement.jumping and not movement.falling and not movement.landed:
		#airborne_blend_value_target = 1
		default_state_machine.travel("jump")
	if movement.falling:
		#airborne_blend_value_target = 1
		default_state_machine.travel("falling")
	if movement.landed:
		#airborne_blend_value_target = 1
		default_state_machine.travel("landing")
	
	#if airborne_blend_value_target == 0 and airborne_blend_value_current > airborne_blend_value_target:
		#airborne_blend_value_current -= delta * transition_speed
		#anim_tree[airborne_blender] = airborne_blend_value_current
	#elif airborne_blend_value_target == 1 and airborne_blend_value_current < airborne_blend_value_target:
		#airborne_blend_value_current += delta * transition_speed
		#anim_tree[airborne_blender] = airborne_blend_value_current
func _apply_twohand_animations(input: Node, _state_controller: Node, movement: Node, _ability: Node, delta: float) -> void:
	if not twohanded: return
	if not movement.jumping and not attack.mainhand_swing:
		twohand_statemachine.travel("idle")
		if input.direction:
			weapon_walk_blend_value_target = clamp(movement.calculated_movement_speed, 0, 1)
		else:
			weapon_walk_blend_value_target = 0
	if attack.mainhand_swing:
		twohand_statemachine.travel("attack{0}".format([attack.mainhand_swing]))
	
	_parry(twohand_statemachine)
	_block(twohand_statemachine)
	_do_stuff(input, _state_controller, movement, _ability, delta, twohand_statemachine)

func _apply_dualwield_animations(input: Node, _state_controller: Node, movement: Node, ability: Node, delta: float) -> void:
	if not dualwield: return
	if not movement.jumping and not ability.busy:
		dualwield_statemachine.travel("idle")
		if input.direction:
			weapon_walk_blend_value_target = clamp(movement.calculated_movement_speed, 0, 1)
		else:
			weapon_walk_blend_value_target = 0
	if attack.mainhand_swing:
		dualwield_statemachine.travel("attack{0}".format([attack.mainhand_swing]))
	
	_parry(dualwield_statemachine)
	_light(dualwield_statemachine)
	_block(dualwield_statemachine)
	_do_stuff(input, _state_controller, movement, ability, delta, dualwield_statemachine)

func _apply_mainhand_animations(input: Node, _state_controller: Node, movement: Node, ability: Node, delta: float) -> void:
	if twohanded or dualwield: return
	if not movement.jumping and not ability.busy:
		mainhand_statemachine.travel("idle")
		if input.direction:
			weapon_walk_blend_value_target = clamp(movement.calculated_movement_speed, 0, 1)
		else:
			weapon_walk_blend_value_target = 0
	if attack.mainhand_swing:
		mainhand_statemachine.travel("attack{0}".format([attack.mainhand_swing]))

	_do_stuff(input, _state_controller, movement, ability, delta, mainhand_statemachine)

func _apply_offhand_animations(input: Node, _state_controller: Node, movement: Node, ability: Node, delta: float) -> void:
	if twohanded or dualwield: return
	if not movement.jumping and not ability.busy:
		offhand_statemachine.travel("idle")
		if input.direction:
			weapon_walk_blend_value_target = clamp(movement.calculated_movement_speed, 0, 1)
		else:
			weapon_walk_blend_value_target = 0
	if attack.offhand_swing:
		offhand_statemachine.travel("activate{0}".format([attack.offhand_swing]))
	
	_light(offhand_statemachine)
	_block(offhand_statemachine)
	_parry(offhand_statemachine)
	_do_stuff(input, _state_controller, movement, ability, delta, offhand_statemachine)

func _do_stuff(_input: Node, _state_controller: Node, movement: Node, ability: Node, _delta: float, statemachine: AnimationNodeStateMachinePlayback):
	if not ability.busy: 
		movement.reset_weapon_modifiers()
		if movement.jumping and not movement.falling and not movement.landed:
			statemachine.travel("jump")
		if movement.falling:
			statemachine.travel("falling")
		if movement.landed:
			statemachine.travel("landing")

func _parry(statemachine: AnimationNodeStateMachinePlayback):
	if parry.parry:
		statemachine.travel("activate1")

func _light(statemachine: AnimationNodeStateMachinePlayback):
	if light.lighting:
		statemachine.travel("activate1")

func _block(statemachine: AnimationNodeStateMachinePlayback):
	if block.blocking:
		statemachine.travel("activate1")

func equipped_two_hand_weapon(weapon_name: String):
	twohand_statemachine.start("idle")
	anim_tree[weapon_blender] = -1
	twohanded = true
	dualwield = false
	var twohand = anim_tree.tree_root.get_node("Twohand")
	twohand.get_node("attack1").animation = "{0}/attack1".format([weapon_name])
	twohand.get_node("attack2").animation = "{0}/attack2".format([weapon_name])
	twohand.get_node("attack3").animation = "{0}/attack3".format([weapon_name])
	twohand.get_node("attack4").animation = "{0}/attack4".format([weapon_name])
	twohand.get_node("activate1").animation = "{0}/activate1".format([weapon_name])
	twohand.get_node("ability1").animation = "{0}/ability1".format([weapon_name])
	twohand.get_node("ability2").animation = "{0}/ability2".format([weapon_name])
	twohand.get_node("idle").get_blend_point_node(0).animation = "{0}/idle".format([weapon_name])
	twohand.get_node("idle").get_blend_point_node(1).animation = "{0}/walking".format([weapon_name])
	twohand.get_node("jump").animation = "{0}/jump".format([weapon_name])
	twohand.get_node("falling").animation = "{0}/falling".format([weapon_name])
	twohand.get_node("landing").animation = "{0}/landing".format([weapon_name])

func equipped_dualwield_weapon(weapon_name: String):
	dualwield_statemachine.start("idle")
	anim_tree[weapon_blender] = 1
	dualwield = true
	twohanded = false
	var anim_name: String = "{0}/dualwield".format([weapon_name])
	var dualwield_tree = anim_tree.tree_root.get_node("Dualwield")
	dualwield_tree.get_node("attack1").animation = "{0}_attack1".format([anim_name])
	dualwield_tree.get_node("attack2").animation = "{0}_attack2".format([anim_name])
	dualwield_tree.get_node("attack3").animation = "{0}_attack3".format([anim_name])
	dualwield_tree.get_node("attack4").animation = "{0}_attack4".format([anim_name])
	dualwield_tree.get_node("activate1").animation = "{0}_activate1".format([anim_name])
	dualwield_tree.get_node("ability1").animation = "{0}_ability1".format([anim_name])
	dualwield_tree.get_node("ability2").animation = "{0}_ability2".format([anim_name])
	dualwield_tree.get_node("idle").get_blend_point_node(0).animation = "{0}_idle".format([anim_name])
	dualwield_tree.get_node("idle").get_blend_point_node(1).animation = "{0}_walking".format([anim_name])
	dualwield_tree.get_node("jump").animation = "{0}_jump".format([anim_name])
	dualwield_tree.get_node("falling").animation = "{0}_falling".format([anim_name])
	dualwield_tree.get_node("landing").animation = "{0}_landing".format([anim_name])

func equpped_mainhand_weapon(weapon_name: String):
	mainhand_statemachine.start("idle")
	anim_tree[weapon_blender] = 0
	twohanded = false
	dualwield = false
	var anim_name: String = "{0}/mainhand".format([weapon_name])
	var mainhand = anim_tree.tree_root.get_node("Mainhand")
	mainhand.get_node("attack1").animation = "{0}_attack1".format([anim_name])
	mainhand.get_node("attack2").animation = "{0}_attack2".format([anim_name])
	mainhand.get_node("attack3").animation = "{0}_attack3".format([anim_name])
	mainhand.get_node("ability1").animation = "{0}_ability1".format([anim_name])
	mainhand.get_node("idle").get_blend_point_node(0).animation = "{0}_idle".format([anim_name])
	mainhand.get_node("idle").get_blend_point_node(1).animation = "{0}_walking".format([anim_name])
	
	mainhand.get_node("jump").animation = "{0}_jump".format([anim_name])
	mainhand.get_node("falling").animation = "{0}_falling".format([anim_name])
	mainhand.get_node("landing").animation = "{0}_landing".format([anim_name])

func equpped_offhand_weapon(weapon_name: String):
	offhand_statemachine.start("idle")
	anim_tree[weapon_blender] = 0
	twohanded = false
	dualwield = false
	var anim_name: String = "{0}/offhand".format([weapon_name])
	var offhand = anim_tree.tree_root.get_node("Offhand")
	offhand.get_node("activate1").animation = "{0}_activate1".format([anim_name])
	offhand.get_node("activate2").animation = "{0}_activate2".format([anim_name])
	offhand.get_node("activate3").animation = "{0}_activate3".format([anim_name])
	offhand.get_node("ability1").animation = "{0}_ability1".format([anim_name])
	offhand.get_node("idle").get_blend_point_node(0).animation = "{0}_idle".format([anim_name])
	offhand.get_node("idle").get_blend_point_node(1).animation = "{0}_walking".format([anim_name])
	
	offhand.get_node("falling").animation = "{0}_falling".format([anim_name])
	offhand.get_node("landing").animation = "{0}_landing".format([anim_name])

func _player_inactive() -> bool:
	return (not _is_attack_active() or not attack.swing) and (not _is_cast_attack_active() or not cast_attack.cast) and (not _is_shoot_attack_active() or not shoot_attack.shoot) and (not _is_block_active() or not block.blocking) and (not _is_parry_active() or not parry.parry) and (not _is_light_active() or not light.lighting) and (not _is_consume_active() or not consume.consuming)

func _is_attack_active() -> bool:
	return attack.process

func _is_cast_attack_active() -> bool:
	return cast_attack.process

func _is_shoot_attack_active() -> bool:
	return shoot_attack.process

func _is_block_active() -> bool:
	return block.process

func _is_parry_active() -> bool:
	return parry.process

func _is_light_active() -> bool:
	return light.process

func _is_consume_active() -> bool:
	return consume.process

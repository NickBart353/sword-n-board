extends Node

@onready var movement_loop_player: AudioStreamPlayer3D = $"../MovementLoopPlayer"
@onready var movement_one_shot_player: AudioStreamPlayer3D = $"../MovementOneShotPlayer"
@onready var voice_player: AudioStreamPlayer3D = $"../VoicePlayer"

@export_group("Randomizers")
@export var walk_sfx: AudioStreamRandomizer
@export var jump_sfx: AudioStreamRandomizer
@export var land_sfx: AudioStreamRandomizer
@export var dash_sfx: AudioStreamRandomizer

var attack: Node
var cast_attack: Node
var shoot_attack: Node
var block: Node
var light: Node
var consume: Node

func apply_audio(state_controller: Node, movement: Node, ability_controller: Node) -> void:
	_apply_movement_audio(state_controller, movement)
	_apply_voice_audio(state_controller, movement, ability_controller)
	#_apply_ability_audio(state_controller, ability_controller)

func _apply_movement_audio(_state_controller: Node, movement: Node) -> void:
	if movement.moving and movement.is_on_floor:
		if not movement_loop_player.playing:
			movement_loop_player.stream = walk_sfx
			movement_loop_player.play()
	else:
		movement_loop_player.stop()
	
	if movement.landed:
		_play_oneshot(land_sfx, 0.05)
	if movement.jumping and movement.is_on_floor:
		_play_oneshot(jump_sfx, 0.05)
	if movement.dash_started:
		_play_oneshot(dash_sfx)

func _play_oneshot(sfx: AudioStream, offset: float = 0.0):
	movement_one_shot_player.stream = sfx
	movement_one_shot_player.play(offset)

func _apply_voice_audio(state_controller: Node, movement: Node, ability_controller: Node) -> void:
	pass

#func _apply_ability_audio(state_controller: Node, ability_controller: Node) -> void:
	#if not attack:
		#ability_controller.get_node("Attack")
	#if not cast_attack:
		#ability_controller.get_node("CastAttack")
	#if not shoot_attack:
		#ability_controller.get_node("ShootAttack")
	#if not block:
		#ability_controller.get_node("Block")
	#if not light:
		#ability_controller.get_node("Light")
	#if not consume:
		#ability_controller.get_node("Consume")
	

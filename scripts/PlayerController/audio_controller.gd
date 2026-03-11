extends Node

@onready var movement_loop_player: AudioStreamPlayer3D = $"../MovementLoopPlayer"
@onready var movement_one_shot_player: AudioStreamPlayer3D = $"../MovementOneShotPlayer"
@onready var voice_player: AudioStreamPlayer3D = $"../VoicePlayer"
@onready var ability_player: AudioStreamPlayer3D = $"../AbilityPlayer"

@export_group("Randomizers")
@export var walk_sfx: AudioStreamRandomizer
@export var jump_sfx: AudioStreamRandomizer
@export var land_sfx: AudioStreamRandomizer
@export var dash_sfx: AudioStreamRandomizer

func apply_audio(state_controller: Node, movement: Node, ability_controller: Node) -> void:
	_apply_movement_audio(state_controller, movement)
	_apply_voice_audio(state_controller, movement, ability_controller)
	_apply_ability_audio(state_controller, ability_controller)

func _apply_movement_audio(state_controller: Node, movement: Node) -> void:
	if movement.moving and movement.is_on_floor:
		if not movement_loop_player.playing:
			movement_loop_player.stream = walk_sfx
			movement_loop_player.play()
	else:
		movement_loop_player.stop()

	if movement.landed:
		_play_oneshot(land_sfx)
	if movement.jumping and movement.is_on_floor:
		_play_oneshot(jump_sfx)
	if movement.dash_started:
		_play_oneshot(dash_sfx)

func _play_oneshot(sfx: AudioStream):
	movement_one_shot_player.stream = sfx
	movement_one_shot_player.play()

func _apply_voice_audio(state_controller: Node, movement: Node, ability_controller: Node) -> void:
	pass

func _apply_ability_audio(state_controller: Node, ability_controller: Node) -> void:
	pass

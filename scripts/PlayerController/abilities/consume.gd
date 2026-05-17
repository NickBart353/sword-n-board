extends Ability

@export_group("Audio")
@export var eating_sound_one: AudioStream
@export var eating_sound_two: AudioStream
@export var drinking_sound_one: AudioStream
@export var drinking_sound_two: AudioStream
@export var ability_player: AudioStreamPlayer3D

signal consume_item
signal finished_consuming

var consumable: Node
var consuming: bool = false
var consumed: bool = false
var process: bool = false

#func set_item(item: Node) -> void:
	#reset()
	#if item is Consumable:
		#consumable = item
		#process = true
		#return
	#process = false
func set_item(mainhand: Node, offhand: Node, dualwield: bool) -> void:
	pass

func apply_ability(input: Node, state_controller: Node, movement: Node, abilities: Node, delta: float) -> void:
	if not process: return
	if not movement.dashing:
		if input.consume and not consuming and not state_controller.is_player_busy():
			state_controller.update_action_state(StateController.ACTION_STATE.CONSUMING)
			consuming = true
			PlayerControls.block_scrolling()
		elif consumed and state_controller.is_player_busy():
			PlayerControls.unblock_scrolling()
			state_controller.reset_action_state()
			finished_consuming.emit()
			consuming = false
			consumed = false

func _consumed():
	consume_item.emit(consumable)

func done_consuming():
	consumed = true

func reset():
	#consumable = null
	consuming = false
	PlayerControls.unblock_scrolling()

func play_consume_sound_one():
	if consumable.data.consumable_type == ConsumableData.CONSUME_TYPE.DRINK:
		ability_player.stream = drinking_sound_one
	else:
		ability_player.stream = eating_sound_one
	ability_player.play()

func play_consume_sound_two():
	if consumable.data.consumable_type == ConsumableData.CONSUME_TYPE.DRINK:
		ability_player.stream = drinking_sound_two
	else:
		ability_player.stream = eating_sound_two
	ability_player.play()

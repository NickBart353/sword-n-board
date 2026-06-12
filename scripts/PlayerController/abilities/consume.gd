extends Node

@export_group("Audio")
@export var eating_sound_one: AudioStream
@export var eating_sound_two: AudioStream
@export var drinking_sound_one: AudioStream
@export var drinking_sound_two: AudioStream
@export var ability_player: AudioStreamPlayer3D

signal start_consuming
signal consume_item
signal finished_consuming

var consumable: Item
var consuming: bool = false
var consumed: bool = false
var process: bool = false
var fire_consuming: bool = false

func set_consumable(new_consumable: Item) -> void:
	if new_consumable is Item:
		consumable = new_consumable
		process = true
	else:
		process = false

func apply_consumable(input: Node, _state_controller: Node, movement: Node, ability: Node, _delta: float) -> void:
	if not process: return
	if not movement.dashing:
		if input.consume and not consuming and not ability.busy:
			start_consuming.emit(consumable)
			ability.busy = true
			consuming = true
			fire_consuming = true
			PlayerControls.block_scrolling()
		elif consumed and ability.busy:
			ability.busy = false
			PlayerControls.unblock_scrolling()
			finished_consuming.emit()
			consuming = false
			consumed = false

func _consumed():
	consume_item.emit(consumable)

func done_consuming():
	consumed = true

func reset():
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

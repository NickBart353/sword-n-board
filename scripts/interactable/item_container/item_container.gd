class_name ItemContainer
extends Interactable

var items: Array = []
var open = false
@export var parent: Node
@export_group("Audio")
@export var open_audio_resource: AudioStream
@export var close_audio_resource: AudioStream
@export_range(-100.0, 100.0) var offset_audio: float = 0.0
@export_range(-100.0, 100.0) var audio_volume: float = 0.0
@export_range(-100.0, 100.0) var audio_max_range: float = 0.0 

signal items_empty

func _ready() -> void:
	super()
	EventBus.update_items.connect(update_items)

func interact():
	super()
	if open:
		open = false
		if close_audio_resource:
			AudioManager.play_audio_from_resource(close_audio_resource, parent.global_position, AudioManager.BUS.SFX, offset_audio, audio_volume, audio_max_range)
		EventBus.close_container.emit(self)
	else:
		if open_audio_resource:
			AudioManager.play_audio_from_resource(open_audio_resource, parent.global_position, AudioManager.BUS.SFX, offset_audio, audio_volume, audio_max_range)
		open = true
		EventBus.open_container.emit(self)

func hover():
	super()
	hovered = true

func un_hover():
	super()
	EventBus.close_container.emit(self)
	open = false
	hovered = false

func update_items(new_items, sack_name):
	if sack_name == parent.name:
		items = new_items
		if items.is_empty():
			EventBus.close_container.emit(self)
			items_empty.emit()

func close_me():
	open = false

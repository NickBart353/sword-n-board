class_name ItemSack
extends RigidBody3D

@export_group("Audio")
@export var audio_resource: AudioStream
@export_range(-100.0, 100.0) var offset_audio: float = 0.0
@export_range(-100.0, 100.0) var audio_volume: float = 0.0
@export_range(-100.0, 100.0) var audio_max_range: float = 0.0 

func _ready() -> void:
	$ItemContainer.items_empty.connect(_remove_me)
	$ItemContainer.parent = self

func _remove_me():
	EventBus.remove_me.emit(self)

func _on_body_entered(body: Node) -> void:
	if body is Terrain3D:
		AudioManager.play_audio_from_resource(audio_resource, global_position, AudioManager.BUS.SFX, offset_audio, audio_volume, audio_max_range)

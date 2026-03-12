class_name FireAndForget extends Node3D

@export var _audio_position: Node3D

func _play_audio_fire_and_forget(resource: AudioStream, bus: AudioManager.BUS, offset: float = 0.0):
	AudioManager.play_audio_from_resource(resource, _audio_position.global_position, bus, offset)

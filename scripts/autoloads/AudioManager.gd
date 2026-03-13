extends Node3D

var number_of_players: int = 32

enum BUS {MASTER, MUSIC, VOICE, SFX}

func play_audio_from_resource(audio_resource: AudioStream, location: Vector3, audio_bus: BUS, offset: float = 0.0):
	var audio_player_instance: AudioStreamPlayer3D = AudioStreamPlayer3D.new()
	add_child(audio_player_instance)
	audio_player_instance.max_polyphony = 4
	audio_player_instance.stream = audio_resource
	audio_player_instance.global_position = location
	match audio_bus:
		BUS.MASTER:
			audio_player_instance.bus = "Master"
		BUS.MUSIC:
			audio_player_instance.bus = "Music"
		BUS.VOICE:
			audio_player_instance.bus = "Voices"
		BUS.SFX:
			audio_player_instance.bus = "SFX"
	audio_player_instance.max_distance = 30.0
	audio_player_instance.play(offset)
	audio_player_instance.finished.connect(audio_player_instance.queue_free)

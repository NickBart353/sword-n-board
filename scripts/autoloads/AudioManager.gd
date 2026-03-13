extends Node3D

var number_of_players: int = 32
var ui_player: AudioStreamPlayer

enum BUS {MASTER, MUSIC, VOICE, SFX, UI, Ambience}

func _ready() -> void:
	ui_player = AudioStreamPlayer.new()
	add_child(ui_player)
	ui_player.bus = "UI"
	ui_player.max_polyphony = 8

func play_audio_from_resource(audio_resource: AudioStream, location: Vector3, audio_bus: BUS, offset: float = 0.0, audio_volume: float = 0.0, audio_max_range: float = 0.0):
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
	audio_player_instance.max_distance = audio_max_range
	audio_player_instance.volume_db = audio_volume
	audio_player_instance.play(offset)
	audio_player_instance.finished.connect(audio_player_instance.queue_free)

func player_ui_sfx(stream: AudioStream):
	ui_player.stream = stream
	ui_player.play()

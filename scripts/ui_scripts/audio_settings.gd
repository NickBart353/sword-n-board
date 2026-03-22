extends GridContainer

const master: String = "Master"
const music: String = "Music"
const voices: String = "Voices"
const sfx: String = "SFX"
const ui: String = "UI"
const ambience: String = "Ambience"

var default_audio_settings: Dictionary = {
	master : 0.8,
	music : 0.8,
	voices : 0.8,
	sfx : 0.8,
	ui : 0.8,
	ambience : 0.8,
	}

var saved_audio_settings: Dictionary = {
	master : 0.8,
	music : 0.8,
	voices : 0.8,
	sfx : 0.8,
	ui : 0.8,
	ambience : 0.8,
	}

var audio_settings: Dictionary = {}

func _ready() -> void:
	audio_settings = default_audio_settings

func parse_volume(volume_dict: Dictionary):
	audio_settings = volume_dict

func reset_volume():
	audio_settings = default_audio_settings

func _on_master_slider_value_changed(value: float) -> void:
	_set_volume(master, value)

func _on_music_slider_value_changed(value: float) -> void:
	_set_volume(music, value)

func _on_voice_slider_value_changed(value: float) -> void:
	_set_volume(voices, value)

func _on_sfx_slider_value_changed(value: float) -> void:
	_set_volume(sfx, value)

func _on_ui_slider_value_changed(value: float) -> void:
	_set_volume(ui, value)

func _on_ambience_slider_value_changed(value: float) -> void:
	_set_volume(ambience, value)

func _set_volume(bus: String, value: float):
	saved_audio_settings[bus] = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus), linear_to_db(value))
	AudioServer.set_bus_mute(AudioServer.get_bus_index(bus), value < 0.05)

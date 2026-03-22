extends GridContainer

@onready var master_slider: HSlider = $MasterSlider
@onready var music_slider: HSlider = $MusicSlider
@onready var voice_slider: HSlider = $VoiceSlider
@onready var sfx_slider: HSlider = $SFXSlider
@onready var ui_slider: HSlider = $UISlider
@onready var ambience_slider: HSlider = $AmbienceSlider

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
	var loaded_volume_dict: Dictionary = DataManager.load_volume()
	if loaded_volume_dict:
		audio_settings = loaded_volume_dict
	else:
		audio_settings = default_audio_settings
	_load_volume()

func _load_volume():
	for key in audio_settings:
		print(db_to_linear(audio_settings[key]), " ", audio_settings[key])
		match key:
			master:
				master_slider.value = audio_settings[key]
			music:
				music_slider.value = audio_settings[key]
			voices:
				voice_slider.value = audio_settings[key]
			sfx:
				sfx_slider.value = audio_settings[key]
			ui:
				ui_slider.value = audio_settings[key]
			ambience:
				ambience_slider.value = audio_settings[key]

func reset_volume():
	audio_settings = default_audio_settings
	_load_volume()

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

func _on_save_button_pressed() -> void:
	DataManager.save_volume(saved_audio_settings)

func _on_reset_button_pressed() -> void:
	DataManager.save_volume(default_audio_settings)
	reset_volume()

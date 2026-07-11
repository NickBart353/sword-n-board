extends GridContainer

signal saved_settings
signal unsaved_settings

@onready var master_slider: HSlider = $MasterSlider
@onready var music_slider: HSlider = $MusicSlider
@onready var voice_slider: HSlider = $VoiceSlider
@onready var sfx_slider: HSlider = $SFXSlider
@onready var ui_slider: HSlider = $UISlider
@onready var ambience_slider: HSlider = $AmbienceSlider

@export var save_button: Button

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

var saved_audio_settings: Dictionary = {}
var audio_settings: Dictionary = {}

var settings_changed: bool

func _ready() -> void:
	settings_changed = false

func load_settings():
	var loaded_volume_dict: Dictionary = DataManager.load_volume()
	if loaded_volume_dict:
		audio_settings = loaded_volume_dict
	else:
		audio_settings = default_audio_settings
	saved_audio_settings = audio_settings.duplicate(true)
	_load_volume()

func _load_volume():
	save_button.disabled = true
	for key in audio_settings:
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
	save_button.disabled = false
	settings_changed = true

func _on_music_slider_value_changed(value: float) -> void:
	_set_volume(music, value)
	save_button.disabled = false
	settings_changed = true

func _on_voice_slider_value_changed(value: float) -> void:
	_set_volume(voices, value)
	save_button.disabled = false
	settings_changed = true

func _on_sfx_slider_value_changed(value: float) -> void:
	_set_volume(sfx, value)
	save_button.disabled = false
	settings_changed = true

func _on_ui_slider_value_changed(value: float) -> void:
	_set_volume(ui, value)
	save_button.disabled = false
	settings_changed = true

func _on_ambience_slider_value_changed(value: float) -> void:
	_set_volume(ambience, value)
	save_button.disabled = false
	settings_changed = true

func _set_volume(bus: String, value: float):
	audio_settings[bus] = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus), linear_to_db(value))
	AudioServer.set_bus_mute(AudioServer.get_bus_index(bus), value < 0.05)

func _on_save_button_pressed() -> void:
	saved_audio_settings = audio_settings.duplicate(true)
	DataManager.save_volume(audio_settings)
	settings_changed = false
	save_button.disabled = true

func _on_reset_button_pressed() -> void:
	audio_settings = default_audio_settings.duplicate(true)
	saved_audio_settings = default_audio_settings.duplicate(true)
	DataManager.save_volume(default_audio_settings)
	reset_volume()
	save_button.disabled = true
	settings_changed = false

func _on_back_button_pressed() -> void:
	if saved_audio_settings == audio_settings:
		saved_settings.emit()
	else:
		unsaved_settings.emit(self)

func reset_current_to_saved() -> void:
	audio_settings = saved_audio_settings.duplicate(true)
	_load_volume()
	save_button.disabled = true
	settings_changed = false

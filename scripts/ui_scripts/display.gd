extends GridContainer

signal saved_settings
signal unsaved_settings

@onready var window_mode_picker: OptionButton = $WindowModePicker
@onready var aspect_ratio_picker: OptionButton = $AspectRatioPicker
@onready var resolution_picker: OptionButton = $ResolutionPicker

@export var save_button: Button

const window_modes: Array[String] = ["Windowed", "Fullscreen", "Borderless"]
const aspect_ratios: Array[String] = ["16:10", "16:9", "21:9", "32:9", "4:3"]

const RESOLUTION_MAPPING: Dictionary = {
		"16:9": [
		{"w": 3840, "h": 2160,},
		{"w": 2560, "h": 1440,},
		{"w": 1920, "h": 1080,},
		{"w": 1600, "h": 900,},
		{"w": 1366, "h": 768,},
		{"w": 1280, "h": 720,},
	],
	"16:10": [
		{"w": 2560, "h": 1600,},
		{"w": 1920, "h": 1200,},
		{"w": 1680, "h": 1050,},
		{"w": 1440, "h": 900,},
		{"w": 1280, "h": 800,},
	],
	"21:9": [
		{"w": 5120, "h": 2160,},
		{"w": 3440, "h": 1440,},
		{"w": 2560, "h": 1080,},
	],
	"32:9": [
		{"w": 5120, "h": 1440,},
		{"w": 3840, "h": 1080,},
	],
	"4:3": [
		{"w": 1600, "h": 1200,},
		{"w": 1440, "h": 1080,},
		{"w": 1280, "h": 960,},
		{"w": 1024, "h": 768,},
		{"w": 800, "h": 600,},
		{"w": 640, "h": 480,},
	]}

const RESOLUTIONS: Array = [
	{"16:9": [
		{"w": 3840, "h": 2160,},
		{"w": 2560, "h": 1440,},
		{"w": 1920, "h": 1080,},
		{"w": 1600, "h": 900,},
		{"w": 1366, "h": 768,},
		{"w": 1280, "h": 720,},
	]},
	{"16:10": [
		{"w": 2560, "h": 1600,},
		{"w": 1920, "h": 1200,},
		{"w": 1680, "h": 1050,},
		{"w": 1440, "h": 900,},
		{"w": 1280, "h": 800,},
	]},
	{"21:9": [
		{"w": 5120, "h": 2160,},
		{"w": 3440, "h": 1440,},
		{"w": 2560, "h": 1080,},
	]},
	{"32:9": [
		{"w": 5120, "h": 1440,},
		{"w": 3840, "h": 1080,},
	]},
	{"4:3": [
		{"w": 1600, "h": 1200,},
		{"w": 1440, "h": 1080,},
		{"w": 1280, "h": 960,},
		{"w": 1024, "h": 768,},
		{"w": 800, "h": 600,},
		{"w": 640, "h": 480,},
	]}
	]

const default_aspect_ratio: String = "16:9"
const default_resolution: Array = [1920, 1080]
const default_window_mode: String = "Fullscreen"

var current_aspect_ratio: String
var current_resolution: Array
var current_window_mode: String

var saved_aspect_ratio: String
var saved_resolution: Array
var saved_window_mode: String

var settings_changed: bool

func _ready() -> void:
	settings_changed = false

func load_settings():
	save_button.disabled = true
	settings_changed = false
	var screen_data: Dictionary = DataManager.load_screen_settings()
	if screen_data:
		current_window_mode = screen_data["window_mode"]
		current_aspect_ratio = screen_data["aspect_ratio"]
		current_resolution = screen_data["resolution"]
	else:
		current_aspect_ratio = default_aspect_ratio
		current_resolution = default_resolution
		current_window_mode = default_window_mode
		
	saved_aspect_ratio = String(current_aspect_ratio)
	saved_resolution = current_resolution.duplicate(true)
	saved_window_mode = String(current_window_mode)
	
	_update_screen()
	_populate_option_menus()

func _populate_option_menus():
	for window_mode in window_modes:
		window_mode_picker.add_item(window_mode)
	window_mode_picker.select(window_modes.find(current_window_mode))
	
	for aspect_ratio in aspect_ratios:
		aspect_ratio_picker.add_item(aspect_ratio)
		if current_aspect_ratio == aspect_ratio:
			aspect_ratio_picker.select(aspect_ratios.find(aspect_ratio))
	
	_update_resolution_selection()

func _update_resolution_selection():
	if current_aspect_ratio:
		for resolution in RESOLUTION_MAPPING[current_aspect_ratio]:
			var resolution_to_add: String = "{0} x {1}".format([resolution["w"], resolution["h"]])
			resolution_picker.add_item(resolution_to_add)
			if [float(resolution["w"]), float(resolution["h"])] == current_resolution:
				resolution_picker.select(RESOLUTION_MAPPING[current_aspect_ratio].find(resolution))

func _update_screen():
	var window: Window = get_window()
	window.size = Vector2i(current_resolution[0], current_resolution[1])
	window.content_scale_size = Vector2i(current_resolution[0], current_resolution[1])
	
	match current_window_mode:
		"Fullscreen":
			DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		"Windowed":
			DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_WINDOWED)
		"Borderless":
			DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_FULLSCREEN)

func _on_save_button_pressed() -> void:
	current_window_mode = window_mode_picker.get_item_text(window_mode_picker.selected)
	current_aspect_ratio = aspect_ratio_picker.get_item_text(aspect_ratio_picker.selected)
	current_resolution = [RESOLUTION_MAPPING[current_aspect_ratio][resolution_picker.selected]["w"], RESOLUTION_MAPPING[current_aspect_ratio][resolution_picker.selected]["h"]]
	
	saved_aspect_ratio = String(current_aspect_ratio)
	saved_resolution = current_resolution.duplicate(true)
	saved_window_mode = String(current_window_mode)
	
	_update_screen()
	DataManager.save_screen_settings({
		"window_mode": current_window_mode,
		"aspect_ratio": current_aspect_ratio,
		"resolution": current_resolution,
	})
	save_button.disabled = true
	settings_changed = false

func _on_reset_button_pressed() -> void:
	current_window_mode = String(default_window_mode)
	current_resolution = default_resolution.duplicate(true)
	current_aspect_ratio = String(default_aspect_ratio)
	
	saved_aspect_ratio = String(current_aspect_ratio)
	saved_resolution = current_resolution.duplicate(true)
	saved_window_mode = String(current_window_mode)
	
	_update_screen()
	DataManager.save_screen_settings({
		"window_mode": current_window_mode,
		"aspect_ratio": current_aspect_ratio,
		"resolution": current_resolution,
	})
	save_button.disabled = true
	settings_changed = false

func _on_back_button_pressed() -> void:
	if saved_aspect_ratio == current_aspect_ratio and saved_resolution == current_resolution and saved_window_mode == current_window_mode:
		saved_settings.emit()
	else:
		unsaved_settings.emit(self)

func reset_current_to_saved() -> void:
	current_aspect_ratio = String(saved_aspect_ratio)
	current_resolution = saved_resolution.duplicate(true)
	current_window_mode = String(saved_window_mode)
	_update_screen()
	_populate_option_menus()
	save_button.disabled = true
	settings_changed = false

func _on_aspect_ratio_picker_item_selected(index: int) -> void:
	save_button.disabled = false
	settings_changed = true
	current_aspect_ratio = aspect_ratio_picker.get_item_text(index)
	resolution_picker.clear()
	_update_resolution_selection()

func _on_window_mode_picker_item_selected(_index: int) -> void:
	save_button.disabled = false
	settings_changed = true

func _on_resolution_picker_item_selected(_index: int) -> void:
	save_button.disabled = false
	settings_changed = true

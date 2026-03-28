extends VBoxContainer

signal new_input
#signal block_input
#signal unblock_input

signal saved_settings
signal unsaved_settings
signal show_keybind_popup
signal show_existing_keybind_popup
signal update_keybind_text
signal hide_keybind_popup
signal hide_existing_keybind_popup

@onready var keybindings: GridContainer = $Keybindings
@onready var main_ui_theme: Theme = preload("res://resources/ui/main_ui_theme.res")
@onready var mouse_sensitivity_slider: HSlider = $MouseInput/MouseSensitivitySlider
@onready var timer: Timer = $Timer

const keyboard_key_event: Dictionary = {"InputType": "InputEventKey", "Keycode": 2 , "DisplayName": "W"}
const mouse_key_event: Dictionary = {"InputType": "InputEventMouseButton", "ButtonIndex": 1, "DisplayName": "LMB"}

const mouse_button_label_dict: Dictionary = {
	MouseButton.MOUSE_BUTTON_LEFT: "LMB",
	MouseButton.MOUSE_BUTTON_RIGHT: "RMB",
	MouseButton.MOUSE_BUTTON_MIDDLE: "MMB",
	MouseButton.MOUSE_BUTTON_WHEEL_UP: "MWU",
	MouseButton.MOUSE_BUTTON_WHEEL_DOWN: "MWD",
	MouseButton.MOUSE_BUTTON_WHEEL_LEFT: "MWL",
	MouseButton.MOUSE_BUTTON_WHEEL_RIGHT: "MWR",
	MouseButton.MOUSE_BUTTON_XBUTTON1: "MBX1",
	MouseButton.MOUSE_BUTTON_XBUTTON2: "MBX2", 
}

const default_input_map: Dictionary = {
	"Primary": {"InputType": "InputEventMouseButton", "ButtonIndex": 2, "DisplayName": "LMB"},
	"Secondary": {"InputType": "InputEventMouseButton", "ButtonIndex": 2, "DisplayName": "RMB"},
	"Move Forward": {"InputType": "InputEventKey", "Keycode": 87 , "DisplayName": "W"},
	"Move Left": {"InputType": "InputEventKey", "Keycode": 65 , "DisplayName": "A"},
	"Move Right": {"InputType": "InputEventKey", "Keycode": 68 , "DisplayName": "D"},
	"Move Backward": {"InputType": "InputEventKey", "Keycode": 83 , "DisplayName": "S"},
	"Interact": {"InputType": "InputEventKey", "Keycode": 69 , "DisplayName": "E"},
	"Consume": {"InputType": "InputEventKey", "Keycode": 81 , "DisplayName": "Q"},
	"Jump": {"InputType": "InputEventKey", "Keycode": 32 , "DisplayName": "Space"},
	"Dash": {"InputType": "InputEventKey", "Keycode": 4194325 , "DisplayName": "Shift"},
	"Open Inventory": {"InputType": "InputEventKey", "Keycode": 4194306 , "DisplayName": "Tab"},
	#"Open Pause Menu": {"InputType": "InputEventKey", "Keycode": 4194305, "DisplayName": "Escape"},
}

const input_keys: Array[String] = [
	"Primary", "Secondary", "Move Forward", "Move Left", "Move Right",
	"Move Backward", "Interact", "Consume", "Jump", "Dash", "Open Inventory", "Open Pause Menu"
]
const default_sensitivity: float = 1.0

var input_map: Dictionary = {}
var saved_input_map
var sensitivity: float = 1.0
var saved_sensitivity

var saved_input: InputEvent
var current_saving_button: InputButton
var already_used_keybind: String
var remapping: bool = false

func load_settings():
	sensitivity = DataManager.load_sensitivity()
	if sensitivity == -1:
		sensitivity = default_sensitivity
	PlayerControls.sensitivity = sensitivity
	mouse_sensitivity_slider.value = sensitivity
	
	input_map = DataManager.load_input_settings()
	if not input_map:
		input_map = default_input_map.duplicate(true)
	PlayerControls.player_input_dictionary = input_map
	
	saved_input_map = input_map.duplicate(true)
	saved_sensitivity = float(sensitivity)
	
	for key in input_map:
		_create_input_action_from_dict(key)
	_populate_keybinds()

func _populate_keybinds():
	for input_name in input_keys:
		for key in input_map:
			if input_name == key:
				var label: Label = Label.new()
				label.theme = main_ui_theme
				label.text = key
				keybindings.add_child(label)
				
				var button: InputButton = InputButton.new()
				button.theme = main_ui_theme
				if input_map[key]:
					button.text = input_map.get(key).get("DisplayName")
				else:
					button.text = "-"
				button.name = key
				if not button.input_pressed.is_connected(_change_input):
					button.input_pressed.connect(_change_input)
				button.add_to_group("FreezeButtons")
				keybindings.add_child(button)
				break

func _change_input(button: InputButton):
	show_keybind_popup.emit()
	remapping = true
	get_tree().call_group("BlockInput", "block_input")
	
	await new_input
	
	current_saving_button = button
	already_used_keybind = _is_new_saved_input_already_used(button)
	
	if not already_used_keybind and saved_input:
		save_new_keybind(button)
	elif not already_used_keybind and not saved_input:
		hide_keybind_popup.emit()
	else:
		show_existing_keybind_popup.emit("{0} Already bound to: {1}\nKeep new binding and unbind: {2}?".format([input_map[already_used_keybind]["DisplayName"], already_used_keybind, already_used_keybind]))

func _input(event: InputEvent) -> void:
	if not remapping:
		return
	if event is InputEventMouseMotion:
		return
	
	if event.is_pressed():
		if event is InputEventKey and event.keycode == 4194305:
			saved_input = null
		else:
			saved_input = event
		remapping = false
		new_input.emit()
		return

func _create_input_action_from_dict(key: String):
	InputMap.action_erase_events(key)
	var new_keybind
	if input_map[key]:
		match input_map[key]["InputType"]:
			"InputEventKey":
				new_keybind = InputEventKey.new()
				new_keybind.keycode = input_map[key]["Keycode"]
			"InputEventMouseButton":
				new_keybind = InputEventMouseButton.new()
				new_keybind.button_index = input_map[key]["ButtonIndex"]
		InputMap.action_add_event(key, new_keybind)

func _on_mouse_sensitivity_slider_value_changed(value: float) -> void:
	#if value <= 1:
	#sensitivity = value
	#else:
		#sensitivity = 1 + 9 * (value - 1)
	sensitivity = value
	PlayerControls.sensitivity = sensitivity

func _on_save_button_pressed() -> void:
	saved_input_map = input_map.duplicate(true)
	saved_sensitivity = float(sensitivity)
	
	DataManager.save_sensitivity(sensitivity)
	DataManager.save_input_settings(input_map)

func _on_reset_button_pressed() -> void:
	input_map = default_input_map.duplicate(true)
	sensitivity = float(default_sensitivity)
	
	saved_input_map = default_input_map.duplicate(true)
	saved_sensitivity = float(default_sensitivity)
	
	DataManager.save_sensitivity(sensitivity)
	DataManager.save_input_settings(input_map)
	PlayerControls.sensitivity = sensitivity
	
	_refresh_keybinds()

func _on_back_button_pressed() -> void:
	if input_map == saved_input_map and sensitivity == saved_sensitivity:
		saved_settings.emit()
	else:
		unsaved_settings.emit(self)

func reset_current_to_saved() -> void:
	input_map = saved_input_map.duplicate(true)
	sensitivity = float(saved_sensitivity)
	PlayerControls.sensitivity = sensitivity
	
	_refresh_keybinds()

func _refresh_keybinds():
	for key in input_map:
		_create_input_action_from_dict(key)
	for child in keybindings.get_children():
		for key in input_map:
			if child is Button and child.name == key:
				if input_map[key]:
					child.text = input_map.get(key).get("DisplayName")
				else:
					child.text = "-"
				break

func _on_timer_timeout() -> void:
	hide_keybind_popup.emit()

func _is_new_saved_input_already_used(button: InputButton):
	if not saved_input:
		return ""
	match saved_input.get_class():
		"InputEventKey":
			for key in input_map:
				if input_map[key] and not button.name == key:
					if input_map[key]["InputType"] == "InputEventKey":
						if saved_input.keycode == input_map[key]["Keycode"]:
							return key
			return ""
		"InputEventMouseButton":
			for key in input_map:
				if input_map[key] and not button.name == key:
					if input_map[key]["InputType"] == "InputEventMouseButton":
						if saved_input.button_index == input_map[key]["ButtonIndex"]:
							return key
			return ""

func save_new_keybind(button) -> void:
	match saved_input.get_class():
		"InputEventKey":
			var new_input_dict: Dictionary = keyboard_key_event.duplicate()
			new_input_dict["InputType"] = "InputEventKey"
			new_input_dict["Keycode"] = saved_input.keycode
			new_input_dict["DisplayName"] = OS.get_keycode_string(saved_input.key_label)
			button.text = OS.get_keycode_string(saved_input.key_label)
			input_map[button.name] = new_input_dict
		"InputEventMouseButton":
			var new_input_dict: Dictionary = keyboard_key_event.duplicate()
			new_input_dict["InputType"] = "InputEventMouseButton"
			new_input_dict["ButtonIndex"] = saved_input.button_index
			new_input_dict["DisplayName"] = mouse_button_label_dict.get(saved_input.button_index)
			button.text = mouse_button_label_dict.get(saved_input.button_index)
			input_map[button.name] = new_input_dict
	_create_input_action_from_dict(button.name)
	update_keybind_text.emit(button.text)
	get_tree().call_group("BlockInput", "unblock_input")
	timer.start()

func _on_keep_new_bind_button_pressed() -> void:
	save_new_keybind(current_saving_button)
	input_map[already_used_keybind] = {}
	_refresh_keybinds()
	hide_existing_keybind_popup.emit()

func _on_cancel_button_pressed() -> void:
	get_tree().call_group("BlockInput", "unblock_input")
	hide_keybind_popup.emit()
	hide_existing_keybind_popup.emit()

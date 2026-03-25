extends VBoxContainer

signal new_input

@onready var keybindings: GridContainer = $Keybindings
@onready var main_ui_theme: Theme = preload("res://resources/ui/main_ui_theme.res")
@onready var mouse_sensitivity_slider: HSlider = $MouseInput/MouseSensitivitySlider

const keyboard_key_event: Dictionary = {"Keycode": 2 , "DisplayName": "W"}
const mouse_key_event: Dictionary = {"ButtonIndex": 1, "DisplayName": "LMB"}

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
	"Primary": "LMB",
	"Secondary": "RMB",
	"Move Forward": "W",
	"Move Left": "A",
	"Move Right": "D",
	"Move Backward": "S",
	"Interact": "E",
	"Consume": "Q",
	"Jump": "Space",
	"Dash": "Shift",
	"Open Inventory": "Tab",
	"Open Pause Menu": "Escape",
}

var input_map: Dictionary = {
	"Primary": "LMB",
	"Secondary": "RMB",
	"Move Forward": "W",
	"Move Left": "A",
	"Move Right": "D",
	"Move Backward": "S",
	"Interact": "E",
	"Consume": "Q",
	"Jump": "Space",
	"Dash": "Shift",
	"Open Inventory": "Tab",
	"Open Pause Menu": "Escape",
}
const default_sensitivity: float = 1.0

var sensitivity: float = 1.0

var saved_input: InputEvent

var remapping: bool = false

func _ready() -> void:
	sensitivity = DataManager.load_sensitivity()
	if sensitivity == -1:
		sensitivity = default_sensitivity
	PlayerControls.sensitivity = sensitivity
	mouse_sensitivity_slider.value = sensitivity
	_populate_keybinds()

func _populate_keybinds():
	for key in default_input_map:
		var label: Label = Label.new()
		label.theme = main_ui_theme
		label.text = key
		keybindings.add_child(label)
		
		var button: InputButton = InputButton.new()
		button.theme = main_ui_theme
		button.text = default_input_map.get(key)
		button.name = key
		if not button.input_pressed.is_connected(_change_input):
			button.input_pressed.connect(_change_input)
		keybindings.add_child(button)

func _change_input(button):
	#var previous_input: String = button.text
	button.text = "Press any button"
	remapping = true
	
	await new_input
	match saved_input.get_class():
		InputEventKey:
			var new_input_dict: Dictionary = keyboard_key_event.duplicate()
			new_input_dict["Keycode"] = saved_input.keycode
			new_input_dict["DisplayName"] = saved_input.key_label
			button.text = saved_input.key_label
			input_map[button.name] = new_input_dict
		InputEventMouseButton:
			var new_input_dict: Dictionary = keyboard_key_event.duplicate()
			new_input_dict["ButtonIndex"] = saved_input.button_index
			new_input_dict["DisplayName"] = mouse_button_label_dict.get(saved_input.button_index)
			button.text = mouse_button_label_dict.get(saved_input.button_index)
			input_map[button.name] = new_input_dict
	#TODO: Check for doubled INPUTS

func _input(event: InputEvent) -> void:
	if not remapping:
		return
	if event is InputEventMouseMotion:
		return
	
	if event.is_pressed():
		saved_input = event
		remapping = false
		new_input.emit()
		return

func _on_mouse_sensitivity_slider_value_changed(value: float) -> void:
#	if value <= 1:
	sensitivity = value
	#else:
		#sensitivity = 1 + 9 * (value - 1)
	PlayerControls.sensitivity = sensitivity

func _on_save_button_pressed() -> void:
	DataManager.save_sensitivity(sensitivity)

func _on_reset_button_pressed() -> void:
	sensitivity = default_sensitivity
	PlayerControls.sensitivity = sensitivity

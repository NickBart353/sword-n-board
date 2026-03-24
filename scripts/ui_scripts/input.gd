extends VBoxContainer

@onready var keybindings: GridContainer = $Keybindings
@onready var main_ui_theme: Theme = preload("res://resources/ui/main_ui_theme.res")

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

var remapping: bool = false

func _ready() -> void:
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
	var previous_input: String = button.text
	button.text = "Press any button"
	remapping = true
	
	input_map.get(button.name)

func _input(event: InputEvent) -> void:
	if not remapping:
		return
	if event is InputEventMouseMotion:
		return
	
	if event.is_pressed():
		print(event)
		remapping = false
		return

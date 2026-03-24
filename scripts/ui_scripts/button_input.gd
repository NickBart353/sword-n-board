class_name InputButton extends Button

signal input_pressed

func _ready() -> void:
	pressed.connect(_pressed)

func _pressed() -> void:
	input_pressed.emit(self)

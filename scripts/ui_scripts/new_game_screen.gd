class_name NewGameScreen extends PanelContainer

signal new_game_screen_closed
signal create_new_game

@onready var text_edit: LineEdit = $VBoxContainer/TextEdit
@onready var back: Button = $VBoxContainer/HBoxContainer/Back
@onready var submit: Button = $VBoxContainer/HBoxContainer/Submit

func _ready() -> void:
	submit.disabled = true

func _on_text_edit_text_changed(new_text: String) -> void:
	if new_text.is_empty():
		submit.disabled = true
	else:
		submit.disabled = false

func _on_back_pressed() -> void:
	new_game_screen_closed.emit()

func _on_submit_pressed() -> void:
	create_new_game.emit(text_edit.text)

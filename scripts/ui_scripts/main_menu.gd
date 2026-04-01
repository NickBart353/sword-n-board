extends Node3D

@onready var main_menu_ui: CanvasLayer = $MainMenuUI

var game_started: bool = false

func _ready() -> void:
	get_tree().paused = false
	main_menu_ui.load_data()
	game_started = false

func _on_main_menu_ui_game_started() -> void:
	game_started = true

func _input(event: InputEvent) -> void:
	if game_started:
		get_viewport().set_input_as_handled()

extends PanelContainer

signal continue_game
signal open_settings
signal main_menu
signal exit_game

func _ready() -> void:
	hide()

func _on_continue_button_pressed() -> void:
	continue_game.emit()

func _on_settings_button_pressed() -> void:
	open_settings.emit()

func _on_main_menu_button_pressed() -> void:
	main_menu.emit()

func _on_exit_game_button_pressed() -> void:
	exit_game.emit()

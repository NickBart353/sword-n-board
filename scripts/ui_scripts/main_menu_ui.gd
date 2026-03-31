extends CanvasLayer

signal game_started

@export_group("Audio")
@export var button_hover_sound: AudioStream
@export var button_click_sound: AudioStream
@export var start_button_click_sound: AudioStream

@onready var main_menu_button_container: PanelContainer = $MainMenuButtonContainer
@onready var settings_menu: PanelContainer = $SettingsMenu

func load_data():
	settings_menu.load_settings()

func _ready() -> void:
	for child in self.find_children("*", "Control", true, false):
		if child is Button and child.disabled == false:
			if not child.mouse_entered.is_connected(_play_hover_sound):
				child.mouse_entered.connect(_play_hover_sound)
			if not child.pressed.is_connected(_play_click_sound):
				child.pressed.connect(_play_click_sound)
	if not $MainMenuButtonContainer/VBoxContainer/StartGame.pressed.is_connected(_pressed_start_button):
		$MainMenuButtonContainer/VBoxContainer/StartGame.pressed.connect(_pressed_start_button)

func _play_hover_sound():
	AudioManager.player_ui_sfx(button_hover_sound)

func _play_click_sound():
	AudioManager.player_ui_sfx(button_click_sound)

func _pressed_start_button():
	AudioManager.player_ui_sfx(start_button_click_sound)
	game_started.emit()

func _on_start_game_pressed() -> void:
	pass # StartGame

func _on_reset_game_pressed() -> void:
	pass # Reset all Game settings and save-files

func _on_settings_pressed() -> void:
	main_menu_button_container.hide()
	settings_menu.show()

func _on_credits_pressed() -> void:
	pass # Show all credits

func _on_exit_game_pressed() -> void:
	get_tree().quit()

func _on_settings_menu_close_settings() -> void:
	main_menu_button_container.show()
	settings_menu.hide()

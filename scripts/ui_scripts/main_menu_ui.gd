extends CanvasLayer

@export_group("Audio")
@export var button_hover_sound: AudioStream
@export var button_click_sound: AudioStream
@export var start_button_click_sound: AudioStream

func _ready() -> void:
	for child in self.find_children("*", "Control", true, false):
		if child is Button:
			if not child.mouse_entered.is_connected(_play_hover_sound):
				child.mouse_entered.connect(_play_hover_sound)
			if not child.pressed.is_connected(_play_click_sound):
				child.pressed.connect(_play_click_sound)
	if not $PanelContainer/VBoxContainer/StartGame.pressed.is_connected(_play_start_sound):
		$PanelContainer/VBoxContainer/StartGame.pressed.connect(_play_start_sound)

func _play_hover_sound():
	AudioManager.player_ui_sfx(button_hover_sound)

func _play_click_sound():
	AudioManager.player_ui_sfx(button_click_sound)

func _play_start_sound():
	AudioManager.player_ui_sfx(start_button_click_sound)

class_name UIInteraction extends Control

@export var hover_sound: AudioStream = preload("uid://dfhfiebievtvw")
@export var click_sound: AudioStream = preload("uid://kr04xc5cc0q")

func _ready() -> void:
	var parent = get_parent()
	if not parent:
		return
	if parent is Control and hover_sound:
		parent.mouse_entered.connect(_play_hover)
	if parent is Button and click_sound:
		parent.pressed.connect(_play_click)

func _play_hover():
	AudioManager.player_ui_sfx(hover_sound)

func _play_click():
	AudioManager.player_ui_sfx(click_sound)

class_name UIInteraction extends Control

@export var hover_sound: AudioStream = preload("uid://dfhfiebievtvw")
@export var click_sound: AudioStream = preload("uid://kr04xc5cc0q")

var parent
var parent_is_control: bool

func _ready() -> void:
	parent = get_parent()
	if not parent:
		return
	parent_is_control = parent is Control
	if parent_is_control and hover_sound:
		parent.mouse_entered.connect(_play_hover)
	if parent is Button and click_sound:
		parent.pressed.connect(_play_click)

func _play_hover():
	if allowed():
		AudioManager.player_ui_sfx(hover_sound)

func _play_click():
	if allowed():
		AudioManager.player_ui_sfx(click_sound)

func allowed() -> bool:
	if parent_is_control:
		if not parent.disabled:
			return true
	return false

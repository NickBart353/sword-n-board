extends CanvasLayer

@onready var hud: Control = $Hud
@onready var item_controller: Control = $ItemController

@onready var pause_menu: Control = $PauseMenu
@onready var settings_menu: Control = $SettingsMenu

@export_group("Audio")
@export var button_hover_sound: AudioStream
@export var button_click_sound: AudioStream

var pause_menu_open: bool
var is_input_blocked: bool

func load_data():
	settings_menu.load_settings()

func _ready() -> void:
	is_input_blocked = false
	pause_menu_open = false
	
	for child in self.find_children("*", "Control", true, false):
		if child is Button:
			if not child.mouse_entered.is_connected(_play_hover_sound):
				child.mouse_entered.connect(_play_hover_sound)
			if not child.pressed.is_connected(_play_click_sound):
				child.pressed.connect(_play_click_sound)
	
	hud.show()
	
	UiController.inventory.connect(_inventory)
	UiController.character_panel.connect(_character_panel)
	UiController.lootbag.connect(_lootbag)
	UiController.escape_menu_signal.connect(_escape_menu)
	UiController._update_healthbar.connect(_update_healthbar)
	UiController._update_staminabar.connect(_update_staminabar)
	UiController._update_manabar.connect(_update_manabar)
	UiController._update_hud.connect(_update_hud)

func _process(_delta: float) -> void:
	if not is_input_blocked:
		if Input.is_action_just_pressed("escape_menu"):
			_escape_menu()
		if Input.is_action_just_pressed("Open Inventory"):
			_inventory()

func _inventory():
	pass

func _character_panel():
	pass

func _lootbag():
	pass

func _escape_menu():
	if not pause_menu_open:
		pause_menu_open = true
		pause_menu.show()
		get_tree().paused = pause_menu_open
	elif pause_menu_open:
		pause_menu_open = false
		pause_menu.hide()
		if settings_menu.is_visible():
			settings_menu.check_for_unsaved_settings()
		else:
			get_tree().paused = pause_menu_open

func _update_healthbar(health: float):
	hud.update_health(health)

func _update_staminabar(stamina: float):
	hud.update_stamina(stamina)

func _update_manabar(mana: float):
	hud.update_mana(mana)

func _update_hud():
	pass

func close_settings() -> void:
	pause_menu.show()
	settings_menu.hide()

func _play_hover_sound():
	AudioManager.player_ui_sfx(button_hover_sound)

func _play_click_sound():
	AudioManager.player_ui_sfx(button_click_sound)

func block_input():
	is_input_blocked = true

func unblock_input():
	is_input_blocked = false

func _on_settings_menu_close_settings() -> void:
	close_settings()

func _on_pause_menu_continue_game() -> void:
	_escape_menu()

func _on_pause_menu_open_settings() -> void:
	settings_menu.show()
	pause_menu.hide()

func _on_pause_menu_main_menu() -> void:
	pass # Replace with function body.

func _on_pause_menu_exit_game() -> void:
	get_tree().quit()

func _on_settings_menu_done_checking() -> void:
	settings_menu.hide()
	get_tree().paused = pause_menu_open

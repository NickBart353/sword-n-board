extends CanvasLayer

@onready var hud: Control = $Hud
@onready var item_controller: Control = $ItemController
@onready var escape_menu: Control = $EscapeMenu
@onready var pause_menu: Control = $EscapeMenu/PauseMenu
@onready var settings_menu: Control = $EscapeMenu/SettingsMenu

@onready var audio: GridContainer = $EscapeMenu/SettingsMenu/SettingsOrganizer/MarginContainer/SettingTabs/Audio/Audio
@onready var input: VBoxContainer = $EscapeMenu/SettingsMenu/SettingsOrganizer/MarginContainer/SettingTabs/Input/ScrollContainer/Input
@onready var display: GridContainer = $EscapeMenu/SettingsMenu/SettingsOrganizer/MarginContainer/SettingTabs/Display/Display

@export_group("Audio")
@export var button_hover_sound: AudioStream
@export var button_click_sound: AudioStream

var escape_menu_open: bool
var block_input: bool

func load_data():
	audio.load_settings()
	input.load_settings()
	display.load_settings()

func _ready() -> void:
	block_input = false
	escape_menu_open = false
	input.block_input.connect(_block_input)
	input.unblock_input.connect(_unblock_input)
	
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
	if not block_input:
		if Input.is_action_just_pressed("escape_menu"):
			_escape_menu()
		if Input.is_action_just_pressed("inventory"):
			_inventory()

func _inventory():
	pass

func _character_panel():
	pass

func _lootbag():
	pass

func _escape_menu():
	if not escape_menu_open:
		escape_menu_open = true
		escape_menu.show()
		pause_menu.show()
	elif escape_menu_open:
		escape_menu_open = false
		pause_menu.hide()
		settings_menu.hide()
		escape_menu.hide()
		
	get_tree().paused = escape_menu_open

func _update_healthbar(health: float):
	hud.update_health(health)

func _update_staminabar(stamina: float):
	hud.update_stamina(stamina)

func _update_manabar(mana: float):
	hud.update_mana(mana)

func _update_hud():
	pass

func _on_continue_button_pressed() -> void:
	_escape_menu()

func _on_settings_button_pressed() -> void:
	settings_menu.show()
	pause_menu.hide()

func _on_back_button_pressed() -> void:
	pause_menu.show()
	settings_menu.hide()

func _play_hover_sound():
	AudioManager.player_ui_sfx(button_hover_sound)

func _play_click_sound():
	AudioManager.player_ui_sfx(button_click_sound)

func _block_input():
	block_input = true

func _unblock_input():
	block_input = false

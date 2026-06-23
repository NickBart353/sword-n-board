extends CanvasLayer

signal return_to_main_menu

@onready var hud: Control = $Hud

@onready var inventory: PanelContainer = $Inventory
@onready var pause_menu: Control = $PauseMenu
@onready var settings_menu: Control = $SettingsMenu
@onready var loot_container: LootContainer = $LootContainer
@onready var chest_item_container: ChestItemContainer = $ChestItemContainer

@export_group("Audio")
@export var button_hover_sound: AudioStream
@export var button_click_sound: AudioStream

var pause_menu_open: bool
var inventory_open: bool
var is_input_blocked: bool

func load_data():
	settings_menu.load_settings()

func _ready() -> void:
	inventory.hide()
	pause_menu.hide()
	settings_menu.hide()
	loot_container.hide()
	chest_item_container.hide()
	
	is_input_blocked = false
	pause_menu_open = false
	inventory_open = false
	
	for child in self.find_children("*", "Control", true, false):
		if child is Button:
			if not child.mouse_entered.is_connected(_play_hover_sound):
				child.mouse_entered.connect(_play_hover_sound)
			if not child.pressed.is_connected(_play_click_sound):
				child.pressed.connect(_play_click_sound)
	
	hud.show()
	
	UiController.inventory.connect(_inventory)
	UiController.character_panel.connect(_character_panel)
	UiController.escape_menu_signal.connect(_escape_menu)
	UiController.item_container_interacted.connect(_open_loot_container)
	UiController #CONNECT OPEN CHEST
	
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
			GameStateSaver.save_game()
		if Input.is_action_just_pressed("Scroll Consumable"):
			_rotate_consumable()
			GameStateSaver.save_game()

func _inventory():
	if not pause_menu_open:
		if loot_container.is_visible():
			_open_loot_container(null)
		#inventory.get_player_items()
		inventory.set_visible(not inventory.is_visible())
		get_tree().paused = inventory.is_visible()
		if inventory.is_visible():
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _character_panel():
	pass

func _open_loot_container(item_container: ItemContainer):
	if loot_container.is_visible():
		loot_container.hide()
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		PlayerControls.unblock_input()
	else:
		loot_container.show()
		loot_container.set_data(item_container)
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		PlayerControls.block_input()

func _escape_menu():
	if loot_container.is_visible():
		_open_loot_container(null)
	if not pause_menu_open:
		if inventory.is_visible():
			_inventory()
		pause_menu_open = true
		pause_menu.show()
		get_tree().paused = pause_menu_open
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	elif pause_menu_open:
		pause_menu_open = false
		pause_menu.hide()
		if settings_menu.is_visible():
			settings_menu.check_for_unsaved_settings()
		else:
			get_tree().paused = pause_menu_open
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _rotate_consumable():
	if not get_tree().paused and not PlayerControls.scrolling_blocked():
		hud.rotate_consumable()

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
	return_to_main_menu.emit()

func _on_pause_menu_exit_game() -> void:
	get_tree().quit()

func _on_settings_menu_done_checking() -> void:
	settings_menu.hide()
	get_tree().paused = pause_menu_open
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_inventory_update_player_items(player_helmet: Item, player_body: Item, player_boots: Item, player_mainhand: Item, player_offhand: Item) -> void:
		UiController.update_player_items_from_inventory(player_helmet, player_body, player_boots, player_mainhand, player_offhand)

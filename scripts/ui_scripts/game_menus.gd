extends CanvasLayer

signal return_to_main_menu
signal player_stuck

@onready var hud: Control = $Hud

@onready var inventory: PanelContainer = $Inventory
@onready var pause_menu: Control = $PauseMenu
@onready var settings_menu: Control = $SettingsMenu
@onready var loot_container: LootContainer = $LootContainer
@onready var chest_item_container: ChestItemContainer = $ChestItemContainer
@onready var world_loot_interface: VBoxContainer = $WorldLootInterface

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
	world_loot_interface.hide()
	
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
	UiController.chest_interacted.connect(_open_chest)
	UiController.player_looted_world_container.connect(_open_world_container)
	
	UiController._update_healthbar.connect(_update_healthbar)
	UiController._update_staminabar.connect(_update_staminabar)
	UiController._update_manabar.connect(_update_manabar)
	UiController._update_hud.connect(_update_hud)
	
	PlayerControls.close_menus.connect(_close_interact_menus)

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
	world_loot_interface.hide()
	if not pause_menu_open:
		if loot_container.is_visible():
			_open_loot_container(null)
		if chest_item_container.is_visible():
			_open_chest(null)
		#inventory.get_player_items()
		inventory.set_visible(not inventory.is_visible())
		get_tree().paused = inventory.is_visible()
		if inventory.is_visible():
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _character_panel():
	pass

func _open_loot_container(item_container: ItemContainer, enemy_name: String = ""):
	world_loot_interface.hide()
	if loot_container.is_visible():
		loot_container.hide()
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		PlayerControls.unblock_input()
		get_tree().paused = false
	else:
		get_tree().paused = true
		loot_container.show()
		loot_container.set_data(item_container, enemy_name)
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		PlayerControls.block_input()

func _open_chest(item_container: ItemContainer):
	world_loot_interface.hide()
	if chest_item_container.is_visible():
		chest_item_container.hide()
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		PlayerControls.unblock_input()
		get_tree().paused = false
	else:
		get_tree().paused = true
		chest_item_container.show()
		chest_item_container.set_data(item_container)
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		PlayerControls.block_input()

func _close_interact_menus() -> void:
	#call_deferred("_close_menus")
	_close_menus()

func _close_menus() -> void:
	if chest_item_container.is_visible():
		chest_item_container.hide()
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		PlayerControls.unblock_input()
		get_tree().paused = false
	if loot_container.is_visible():
		loot_container.hide()
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		PlayerControls.unblock_input()
		get_tree().paused = false

func _escape_menu():
	world_loot_interface.hide()
	if loot_container.is_visible():
		_open_loot_container(null)
		return
	if inventory.is_visible():
		_inventory()
		return
	if chest_item_container.is_visible():
		_open_chest(null)
		return
	if not pause_menu_open:
		pause_menu_open = true
		pause_menu.show()
		get_tree().paused = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	elif pause_menu_open:
		pause_menu_open = false
		pause_menu.hide()
		if settings_menu.is_visible():
			settings_menu.check_for_unsaved_settings()
		else:
			get_tree().paused = false
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _open_world_container(item_datas: Array[ItemData]) -> void:
	var items: Array = item_datas.map(ItemManager.get_item_from_itemdata) as Array[Item]
	inventory.add_items_to_inventory(items)
	world_loot_interface.populate_menu(items)
	world_loot_interface.show()

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

func _on_world_loot_interface_close_me() -> void:
	world_loot_interface.hide()

func _on_pause_menu_player_stuck() -> void:
	player_stuck.emit()

extends Node

signal inventory
signal character_panel
signal lootbag
signal escape_menu_signal

signal update_player_items
signal get_updated_player_items
signal new_player_items
signal set_player_consumables

signal _update_healthbar
signal _update_staminabar
signal _update_manabar
signal _update_hud

var ui_open: bool
var inventory_open: bool
var lootbag_open: bool
var escape_menu_open: bool

func _ready() -> void:
	ui_open = false
	inventory_open = false
	lootbag_open = false
	escape_menu_open = false

func update_healthbar(val: float):
	_update_healthbar.emit(val)

func update_staminabar(val: float):
	_update_staminabar.emit(val)

func update_manabar(val: float):
	_update_manabar.emit(val)

func update_hud(val: int):
	_update_hud.emit(val)

func escape_menu():
	escape_menu_open = !escape_menu_open
	ui_open = escape_menu_open
	get_tree().paused = escape_menu_open
	escape_menu_signal.emit()

func get_player_items():
	get_updated_player_items.emit()

func give_updated_player_items(updated_player_items: Array, updated_player_consumables: Array, updated_player_helmet: Item, updated_player_body: Item, updated_player_boots: Item, updated_player_mainhand: Item, updated_player_offhand: Item) -> void:
	update_player_items.emit(updated_player_items, updated_player_consumables, updated_player_helmet, updated_player_body, updated_player_boots, updated_player_mainhand, updated_player_offhand)

func update_player_items_from_inventory(player_items: Array, player_consumables: Array, player_helmet: Item, player_body: Item, player_boots: Item, player_mainhand: Item, player_offhand: Item) -> void:
	new_player_items.emit(player_items, player_consumables, player_helmet, player_body, player_boots, player_mainhand, player_offhand)
	#set_player_consumables.emit(player_consumables)

func update_player_consumables(player_consumables: Array):
	set_player_consumables.emit(player_consumables)
	print("fest")

func is_ui_open() -> bool:
	return ui_open

extends Node

signal inventory
signal character_panel
signal lootbag
signal escape_menu_signal

signal update_player_items
signal get_updated_player_items

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

func give_updated_player_items(updated_player_items: Array):
	update_player_items.emit(updated_player_items)

func is_ui_open() -> bool:
	return ui_open

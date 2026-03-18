extends Node

var ui_open: bool

signal inventory
signal character_panel
signal lootbag
signal game_menu

signal _update_healthbar
signal _update_staminabar
signal _update_manabar
signal _update_hud

func update_healthbar(val: float):
	_update_healthbar.emit(val)

func update_staminabar(val: float):
	_update_staminabar.emit(val)

func update_manabar(val: float):
	_update_manabar.emit(val)

func update_hud(val: int):
	_update_hud.emit(val)

func is_ui_open() -> bool:
	return ui_open

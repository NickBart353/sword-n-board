extends Node

signal inventory
signal character_panel
signal lootbag
signal escape_menu_signal

signal new_player_items
signal set_player_consumables
signal new_mainhand
signal new_offhand
signal added_item_to_inventory

signal new_consumable
signal player_consumed_item
signal remove_consumable

signal item_container_interacted

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

#func update_player_items_from_inventory(player_items: Array, player_consumables: Array, player_helmet: Item, player_body: Item, player_boots: Item, player_mainhand: Item, player_offhand: Item) -> void:
#	new_player_items.emit(player_items, player_consumables, player_helmet, player_body, player_boots, player_mainhand, player_offhand)
	#set_player_consumables.emit(player_consumables)
func update_player_items_from_inventory(player_helmet: Item, player_body: Item, player_boots: Item, player_mainhand: Item, player_offhand: Item) -> void:
	new_player_items.emit(player_helmet, player_body, player_boots, player_mainhand, player_offhand)

func update_player_consumables(player_consumables: Array):
	set_player_consumables.emit(player_consumables)

func give_player_new_consumable(item: Item):
	new_consumable.emit(item)

func update_hud_mainhand(player_mainhand: Item):
	new_mainhand.emit(player_mainhand)

func update_hud_offhand(player_offhand: Item, two_hand_duplicate: bool):
	new_offhand.emit(player_offhand, two_hand_duplicate)

func consumed(item: Item):
	player_consumed_item.emit(item)

func remove_consumable_from_inventory(item: Item, remove_stack: bool):
	remove_consumable.emit(item, remove_stack)

func interact_with_loot_container(item_container: ItemContainer):
	item_container_interacted.emit(item_container)

func add_item_to_inventory(item: Item):
	added_item_to_inventory.emit(item)

func is_ui_open() -> bool:
	return ui_open

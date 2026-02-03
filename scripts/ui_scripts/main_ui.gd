extends Control

@onready var inventory = $PlayerInventory
@onready var loot = $Loot
@onready var loot_list = $Loot/LootList
@onready var head = $Character/Head
@onready var body = $Character/Body
@onready var boots = $Character/Boots
@onready var main_hand = $Character/MainHand
@onready var off_hand = $Character/OffHand
@onready var consumable = $Character/OffHand

var player_items: Array = []
var loot_items: Array = []
var equipped_head: Item
var equipped_body: Item
var equipped_boot: Item
var equipped_main_hand: Item
var equipped_off_hand: Item
var equipped_consumable: Item

var last_open_sack

var ui_open: bool

signal update_items

func _set_mouse_capture(captured: bool):
	if captured:
		Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func open_inventory():
	print(player_items)
	if inventory.is_visible():
		_set_mouse_capture(false)
		inventory.set_visible(false)
		loot.set_visible(false)
		_clear_lists()
		last_open_sack = null
	elif not inventory.is_visible():
		_set_mouse_capture(true)
		_clear_lists()
		_refill_lists()
		inventory.set_visible(true)

func open_sack(current_open_sack):
	_set_mouse_capture(true)
	_clear_lists()
	_refill_lists()
	last_open_sack = current_open_sack
	loot.set_visible(true)
	inventory.set_visible(true)

func close_sack(_sack):
	_set_mouse_capture(false)
	inventory.set_visible(false)
	loot.set_visible(false)
	last_open_sack = null
	_clear_lists()

func get_inventory():
	return inventory.is_visible()

func _refill_lists():
	for item in loot_items:
		var item_index = loot_list.add_icon_item(item.data.sprite)
		_set_item_data(item_index, loot_list, item.data)
	for item in player_items:
		var item_index = inventory.add_icon_item(item.data.sprite)
		_set_item_data(item_index, inventory, item.data)

func _clear_lists():
	loot_list.clear()
	inventory.clear()

func fill_loot(items):
	loot_items = items

func fill_inventory(items):
	player_items = items

func _on_player_inventory_item_activated(index: int) -> void:
	if loot.is_visible():
		loot_items.append(player_items[index])
		player_items.remove_at(index)
		_update_items()
	else:
		match player_items[index].data.item_type:
			ItemData.ITEM_TYPE.MELEE_WEAPON:
				if equipped_main_hand:
					pass
				else:
					pass
			ItemData.ITEM_TYPE.RANGED_WEAPON:
				if equipped_main_hand:
					pass
				else:
					pass
			ItemData.ITEM_TYPE.MAGIC_WEAPON:
				if equipped_main_hand:
					pass
				else:
					pass
			ItemData.ITEM_TYPE.OFF_HAND:
				if equipped_off_hand:
					pass
				else:
					pass
			ItemData.ITEM_TYPE.CONSUMABLE:
				if equipped_consumable:
					pass
				else:
					pass
		

func _on_loot_list_item_activated(index: int) -> void:
	if player_items.size() < 9:
		player_items.append(loot_items[index])
		loot_items.remove_at(index)
		_update_items()
	else:
		#POPUP inventory FULL
		pass

func _update_items():
	update_items.emit(player_items, loot_items, last_open_sack)
	_clear_lists()
	_refill_lists()

func _set_item_data(index, list, data):
	#list.set_item_text(index, data.item_name)
	list.set_item_tooltip_enabled(index, true)
	#list.set_item_tooltip(index, data.tooltip)
	list.set_item_tooltip(index, data.item_name)

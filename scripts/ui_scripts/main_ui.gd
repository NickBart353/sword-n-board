extends Control

@onready var loot = $Loot
@onready var character = $Character
@onready var inventory = $Inventory

@onready var inventory_list = $Inventory/InventoryList
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
var equipped_boots: Item
var equipped_main_hand: Item
var equipped_off_hand: Item
var equipped_consumable: Item

var last_open_sack

var ui_open: bool = false

signal update_items

func _set_mouse_capture(captured: bool):
	if captured:
		Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func open_inventory():
	if inventory.is_visible():
		ui_open = false
		_set_mouse_capture(false)
		inventory.set_visible(false)
		character.set_visible(false)
		loot.set_visible(false)
		_clear_lists()
		last_open_sack = null
	elif not inventory.is_visible():
		ui_open = true
		_set_mouse_capture(true)
		_clear_lists()
		_refill_lists()
		inventory.set_visible(true)
		character.set_visible(true)

func open_sack(current_open_sack):
	ui_open = true
	_set_mouse_capture(true)
	_clear_lists()
	_refill_lists()
	last_open_sack = current_open_sack
	loot.set_visible(true)
	inventory.set_visible(true)

func close_sack(_sack):
	ui_open = false
	_set_mouse_capture(false)
	inventory.set_visible(false)
	loot.set_visible(false)
	last_open_sack = null
	_clear_lists()

func get_inventory():
	return inventory.is_visible()

func get_character():
	return character.is_visible()

func get_ui() -> bool:
	return ui_open

func _refill_lists():
	var item_index: int
	for item in loot_items:
		item_index = loot_list.add_icon_item(item.data.sprite)
		_set_item_data(item_index, loot_list, item.data)
	
	for item in player_items:
		item_index = inventory_list.add_icon_item(item.data.sprite)
		_set_item_data(item_index, inventory_list, item.data)
	
	if equipped_head:
		item_index = head.add_icon_item(equipped_head.data.sprite)
		_set_item_data(item_index, head, equipped_head.data)
	
	if equipped_body:
		item_index = body.add_icon_item(equipped_body.data.sprite)
		_set_item_data(item_index, body, equipped_body.data)
	
	if equipped_boots:
		item_index = boots.add_icon_item(equipped_boots.data.sprite)
		_set_item_data(item_index, boots, equipped_boots.data)
	
	if equipped_main_hand:
		item_index = main_hand.add_icon_item(equipped_main_hand.data.sprite)
		_set_item_data(item_index, main_hand, equipped_main_hand.data)
	
	if equipped_off_hand:
		item_index = off_hand.add_icon_item(equipped_off_hand.data.sprite)
		_set_item_data(item_index, off_hand, equipped_off_hand.data)
	
	if equipped_consumable:
		item_index = consumable.add_icon_item(equipped_consumable.data.sprite)
		_set_item_data(item_index, consumable, equipped_consumable.data)

func _clear_lists():
	loot_list.clear()
	inventory_list.clear()
	head.clear()
	body.clear()
	boots.clear()
	main_hand.clear()
	off_hand.clear()
	consumable.clear()

func fill_loot(items):
	loot_items = items

func fill_inventory(items):
	player_items = items

func fill_head(item: Item):
	equipped_head = item

func fill_body(item: Item):
	equipped_body = item

func fill_boots(item: Item):
	equipped_boots = item

func fill_main_hand(item: Item):
	equipped_main_hand = item

func fill_off_hand(item: Item):
	equipped_off_hand = item

func fill_consumable(item: Item):
	equipped_consumable = item

func _on_player_inventory_item_activated(index: int) -> void:
	if loot.is_visible():
		loot_items.append(player_items[index])
		player_items.remove_at(index)
		_update_items()
	else:
		match player_items[index].data.item_type:
			ItemData.ITEM_TYPE.MELEE_WEAPON:
				if equipped_main_hand:
					equipped_main_hand = player_items[index]
					player_items.remove_at(index)
				else:
					player_items.append(equipped_main_hand)
					equipped_main_hand = null
			ItemData.ITEM_TYPE.RANGED_WEAPON:
				if equipped_main_hand:
					equipped_main_hand = player_items[index]
					player_items.remove_at(index)
				else:
					player_items.append(equipped_main_hand)
					equipped_main_hand = null
			ItemData.ITEM_TYPE.MAGIC_WEAPON:
				if equipped_main_hand:
					equipped_main_hand = player_items[index]
					player_items.remove_at(index)
				else:
					player_items.append(equipped_main_hand)
					equipped_main_hand = null
			ItemData.ITEM_TYPE.OFF_HAND:
				if equipped_off_hand:
					equipped_off_hand = player_items[index]
					player_items.remove_at(index)
				else:
					player_items.append(equipped_off_hand)
					equipped_off_hand = null
			ItemData.ITEM_TYPE.CONSUMABLE:
				if equipped_consumable:
					equipped_consumable = player_items[index]
					player_items.remove_at(index)
				else:
					player_items.append(equipped_consumable)
					equipped_consumable = null
		_update_items()

func _on_loot_list_item_activated(index: int) -> void:
	if player_items.size() < 9:
		player_items.append(loot_items[index])
		loot_items.remove_at(index)
		_update_items()
	else:
		print("Inventory full!")

func _update_items():
	update_items.emit(player_items, loot_items, last_open_sack)
	_clear_lists()
	_refill_lists()

func _set_item_data(index, list, data):
	#list.set_item_text(index, data.item_name)
	#list.set_item_tooltip(index, data.tooltip)
	
	list.set_item_tooltip_enabled(index, true)
	list.set_item_tooltip(index, data.item_name)

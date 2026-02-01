extends Control

var player_items: Array = []
var loot_items: Array = []
var last_open_sack

var ui_open: bool

signal update_items

func _set_mouse_capture(captured: bool):
	if captured:
		Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func open_inventory():
	if $PlayerInventory.is_visible():
		_set_mouse_capture(false)
		$PlayerInventory.set_visible(false)
		$Loot.set_visible(false)
		_clear_lists()
		last_open_sack = null
	elif not $PlayerInventory.is_visible():
		_set_mouse_capture(true)
		_clear_lists()
		_refill_lists()
		$PlayerInventory.set_visible(true)

func open_sack(current_open_sack):
	_set_mouse_capture(true)
	_clear_lists()
	_refill_lists()
	last_open_sack = current_open_sack
	$Loot.set_visible(true)
	$PlayerInventory.set_visible(true)

func close_sack(_sack):
	_set_mouse_capture(false)
	$PlayerInventory.set_visible(false)
	$Loot.set_visible(false)
	last_open_sack = null
	_clear_lists()

func get_inventory():
	return $PlayerInventory.is_visible()

func _refill_lists():
	for item in loot_items:
		var item_index = $Loot/LootList.add_icon_item(item.data.sprite)
		_set_item_data(item_index, $Loot/LootList, item.data)
	for item in player_items:
		var item_index = $PlayerInventory.add_icon_item(item.data.sprite)
		_set_item_data(item_index, $PlayerInventory, item.data)

func _clear_lists():
	$Loot/LootList.clear()
	$PlayerInventory.clear()

func fill_loot(items):
	loot_items = items

func fill_inventory(items):
	player_items = items

func _on_player_inventory_item_activated(index: int) -> void:
	if $Loot.is_visible():
		loot_items.append(player_items[index])
		player_items.remove_at(index)
		_update_items()
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

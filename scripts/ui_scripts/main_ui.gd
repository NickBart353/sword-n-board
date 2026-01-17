extends Control

var player_items = []
var loot_items = []
var last_open_sack

signal update_items

func open_inventory():
	if $PlayerInventory.is_visible():
		$PlayerInventory.set_visible(false)
		$Loot.set_visible(false)
		_clear_lists()
		last_open_sack = null
	elif not $PlayerInventory.is_visible():
		_refill_lists()
		$PlayerInventory.set_visible(true)

func open_sack(current_open_sack):
	#if not $PlayerInventory.is_visible():
	_clear_lists()
	_refill_lists()
	last_open_sack = current_open_sack
	$Loot.set_visible(true)
	$PlayerInventory.set_visible(true)

func close_sack():
	$PlayerInventory.set_visible(false)
	$Loot.set_visible(false)
	last_open_sack = null
	_clear_lists()

func get_inventory():
	return $PlayerInventory.is_visible()

func _refill_lists():
	for item in loot_items:
		$Loot/LootList.add_icon_item(item.data.sprite)
	for item in player_items:
		$PlayerInventory.add_icon_item(item.data.sprite)

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

extends Control

var player_items = []
var loot_items = []

signal update_items

func open_inventory():
	if $PlayerInventory.is_visible():
		$PlayerInventory.set_visible(false)
		$Loot.set_visible(false)
		_clear_lists()
	elif not $PlayerInventory.is_visible():
		_refill_lists()
		$PlayerInventory.set_visible(true)

func open_sack():
	_refill_lists()
	$Loot.set_visible(true)
	$PlayerInventory.set_visible(true)

func close_sack():
	$PlayerInventory.set_visible(false)
	$Loot.set_visible(false)
	_clear_lists()

func get_inventory():
	return $PlayerInventory.is_visible()

func _refill_lists():
	for item in loot_items:
		$Loot/LootList.add_item(item.data.item_name)
	for item in player_items:
			$PlayerInventory.add_item(item.data.item_name)

func _clear_lists():
	$Loot/LootList.clear()
	$PlayerInventory.clear()

func fill_loot(items):
	loot_items = items

func fill_inventory(items):
	player_items = items

func _on_player_inventory_item_activated(_index: int) -> void:
	pass # USE ITEM

func _on_loot_list_item_activated(index: int) -> void:
	player_items.append(loot_items[index])
	loot_items.remove_at(index)
	_update_items()

func _update_items():
	update_items.emit(player_items, loot_items)
	_clear_lists()
	_refill_lists()

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
@onready var consumable = $Character/Consumable

var player_items: Array = []
var loot_items: Array = []
var equipped_head: Item
var equipped_body: Item
var equipped_boots: Item
var equipped_main_hand: Item
var equipped_off_hand: Item
var equipped_consumable: Item

var last_open_sack: Node
#var last_open_sack_instance: Node

var ui_open: bool = false

signal update_items

@export_group("Audio")
@export var open_inventory_sound: AudioStream
@export var close_inventory_sound: AudioStream
@export var mouse_hover_sounds: AudioStream

func _ready() -> void:
	connect_mouse_hover_signals(self)

func connect_mouse_hover_signals(ui_node: Control):
	for child in self.find_children("*", "Control", true, false):
		if child is Control:
			if not child.mouse_entered.is_connected(_play_hover_sound):
				child.mouse_entered.connect(_play_hover_sound)

func _play_hover_sound():
	AudioManager.player_ui_sfx(mouse_hover_sounds)

func _set_mouse_capture(captured: bool):
	if captured:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func open_inventory():
	if inventory.is_visible():
		AudioManager.player_ui_sfx(close_inventory_sound)
		_clear_lists()
		_refill_lists()
		ui_open = false
		_set_mouse_capture(false)
		inventory.set_visible(false)
		character.set_visible(false)
		if loot.is_visible() and last_open_sack:
			last_open_sack.close_me()
		loot.set_visible(false)
		last_open_sack = null
	elif not inventory.is_visible():
		AudioManager.player_ui_sfx(open_inventory_sound)
		ui_open = true
		_set_mouse_capture(true)
		inventory.set_visible(true)
		character.set_visible(true)
		_clear_lists()
		_refill_lists()

func open_sack(current_open_sack: Node):
	ui_open = true
	_set_mouse_capture(true)
	_clear_lists()
	_refill_lists()
	last_open_sack = current_open_sack
	loot.set_visible(true)
	inventory.set_visible(true)
	character.set_visible(false)

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
	_fill_list(loot_list, loot_items)
	_fill_list(inventory_list, player_items)
	
	_fill_slots(equipped_head, head)
	_fill_slots(equipped_body, body)
	_fill_slots(equipped_boots, boots)
	_fill_slots(equipped_main_hand, main_hand)
	_fill_slots(equipped_off_hand, off_hand)
	_fill_slots(equipped_consumable, consumable)

func _fill_list(display_list: Node, item_list: Array):
	for item in item_list:
		var item_index: int = display_list.add_icon_item(item.data.sprite)
		_set_item_data(item_index, display_list, item.data)

func _fill_slots(item: Item, slot: Node):
	if item:
		var item_index: int = slot.add_icon_item(item.data.sprite)
		_set_item_data(item_index, slot, item.data)

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

func fill_character_items(p_inventory, p_head, p_body, p_boots, p_main_hand, p_off_hand, p_consumable):
	player_items = p_inventory
	equipped_head = p_head
	equipped_body = p_body
	equipped_boots = p_boots
	equipped_main_hand = p_main_hand
	equipped_off_hand = p_off_hand
	equipped_consumable = p_consumable

#func _on_player_inventory_item_activated(index: int) -> void:
	#if loot.is_visible():
		#loot_items.append(player_items[index])
		#player_items.remove_at(index)
		#_update_items()
	#else:
		#match player_items[index].data.item_category:
			#ItemData.ITEM_CATEGORY.MELEE_WEAPON:
				#_swap_weapons(true, index)
			#ItemData.ITEM_CATEGORY.RANGED_WEAPON:
				#_swap_weapons(true, index)
			#ItemData.ITEM_CATEGORY.MAGIC_WEAPON:
				#_swap_weapons(true, index)
			#ItemData.ITEM_CATEGORY.OFF_HAND:
				#_swap_weapons(false, index)
			#ItemData.ITEM_CATEGORY.CONSUMABLE:
				#equipped_consumable = _swap_items(equipped_consumable, index)
		#_update_items()

func _swap_weapons(is_main_hand: bool, index: int):
	if is_main_hand:
		if equipped_main_hand:
			if player_items[index].data.two_handed:
				var temp_main_hand: Item = equipped_main_hand
				var temp_off_hand: Item = equipped_off_hand
				if not _two_handed_weapon_equipped() and equipped_off_hand:
					player_items.append(temp_off_hand)
				equipped_main_hand = player_items[index]
				equipped_off_hand = player_items[index]
				player_items.remove_at(index)
				player_items.append(temp_main_hand)
			else:
				if _two_handed_weapon_equipped(): 
					equipped_off_hand = null
				var temp_item: Item = equipped_main_hand
				equipped_main_hand = player_items[index]
				player_items.remove_at(index)
				player_items.append(temp_item)
		else:
			if player_items[index].data.two_handed:
				if equipped_off_hand:
					player_items.append(equipped_off_hand)
				equipped_main_hand = player_items[index]
				equipped_off_hand = player_items[index]
				player_items.remove_at(index)
			else:
				equipped_main_hand = player_items[index]
				player_items.remove_at(index)
	else:
		if not equipped_off_hand:
			equipped_off_hand = player_items[index]
			player_items.remove_at(index)
		elif equipped_off_hand and equipped_off_hand != equipped_main_hand:
			var temp_item: Item = equipped_off_hand
			equipped_off_hand = player_items[index]
			player_items.remove_at(index)
			player_items.append(temp_item)
		elif _two_handed_weapon_equipped():
			var temp_item: Item = equipped_main_hand
			equipped_main_hand = null
			equipped_off_hand = player_items[index]
			player_items.remove_at(index)
			player_items.append(temp_item)

func _swap_items(slot: Item, index: int):
	#if slot and slot == player_items[index] and slot.stackable:
	if slot:
		var temp_item: Item = slot
		slot = player_items[index]
		player_items.remove_at(index)
		player_items.append(temp_item)
	else:
		slot = player_items[index]
		player_items.remove_at(index)
	return slot

func _two_handed_weapon_equipped():
	return equipped_main_hand == equipped_off_hand

#func _on_loot_list_item_activated(index: int) -> void:
	#if player_items.size() < 9:
		#player_items.append(loot_items[index])
		#loot_items.remove_at(index)
		#_update_items()
	#else:
		#print("Inventory full!")

func _update_items():
	update_items.emit(player_items, loot_items, last_open_sack, equipped_head, equipped_body, equipped_boots, equipped_main_hand, equipped_off_hand, equipped_consumable)
	_clear_lists()
	_refill_lists()

func _set_item_data(index, list, data):
	#list.set_item_text(index, data.item_name)
	#list.set_item_tooltip(index, data.tooltip)
	
	list.set_item_tooltip_enabled(index, true)
	list.set_item_tooltip(index, data.item_name)


#func _on_inventory_list_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	#if loot.is_visible():
		#loot_items.append(player_items[index])
		#player_items.remove_at(index)
		#_update_items()
	#else:
		#match player_items[index].data.item_category:
			#ItemData.ITEM_CATEGORY.MELEE_WEAPON:
				#_swap_weapons(true, index)
			#ItemData.ITEM_CATEGORY.RANGED_WEAPON:
				#_swap_weapons(true, index)
			#ItemData.ITEM_CATEGORY.MAGIC_WEAPON:
				#_swap_weapons(true, index)
			#ItemData.ITEM_CATEGORY.OFF_HAND:
				#_swap_weapons(false, index)
			#ItemData.ITEM_CATEGORY.CONSUMABLE:
				#equipped_consumable = _swap_items(equipped_consumable, index)
		#_update_items()

func take_item_from_list(index: int, list: Array):
	#if list[index].data.stackable:
		#print("test1")
		#match list[index].data.item_category:
				#ItemData.ITEM_CATEGORY.MELEE_WEAPON:
					#pass
				#ItemData.ITEM_CATEGORY.RANGED_WEAPON:
					#pass
				#ItemData.ITEM_CATEGORY.MAGIC_WEAPON:
					#pass
				#ItemData.ITEM_CATEGORY.OFF_HAND:
					#pass
				#ItemData.ITEM_CATEGORY.CONSUMABLE:
					#print("test2")
					#if equipped_consumable == list[index]:
						#print("test3")
						#list.remove_at(index)
						#equipped_consumable.data.stack_size += 1
					#else:
						#for item in loot_items:
							#if item == list[index]:
								#print("5")
								#list.remove_at(index)
								#equipped_consumable.data.stack_size += 1
	if player_items.size() < 9:
		player_items.append(list[index])
		list.remove_at(index)
		_update_items()
	else:
		print("Inventory full!")

func take_item_from_slot(index: int, slot: Item):
	if player_items.size() < 9:
		player_items.append(slot)
		slot = null
		_update_items()
	else:
		print("Inventory full!")

func fill_player_items(new_player_items: Array, new_equipped_head: Item, new_equipped_body: Item, new_equipped_boots: Item, new_equipped_main_hand: Item, new_equipped_off_hand: Item, new_equipped_consumable: Item):
	_clear_lists()
	player_items = new_player_items
	equipped_head = new_equipped_head
	equipped_body = new_equipped_body
	equipped_boots = new_equipped_boots
	equipped_main_hand = new_equipped_main_hand
	equipped_off_hand = new_equipped_off_hand
	equipped_consumable = new_equipped_consumable
	_refill_lists()

func _on_loot_list_item_clicked(index: int, _at_position: Vector2, _mouse_button_index: int) -> void:
	take_item_from_list(index, loot_items)

func _on_off_hand_item_clicked(index: int, _at_position: Vector2, _mouse_button_index: int) -> void:
	if equipped_off_hand == equipped_main_hand:
		equipped_main_hand = null
	equipped_off_hand = take_item_from_slot(index, equipped_off_hand)
	_update_items()

func _on_main_hand_item_clicked(index: int, _at_position: Vector2, _mouse_button_index: int) -> void:
	if equipped_off_hand == equipped_main_hand:
		equipped_off_hand = null
	equipped_main_hand = take_item_from_slot(index, equipped_main_hand)
	_update_items()

func _on_consumable_item_clicked(index: int, _at_position: Vector2, _mouse_button_index: int) -> void:
	equipped_consumable = take_item_from_slot(index, equipped_consumable)
	_update_items()

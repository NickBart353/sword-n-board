extends PanelContainer

signal update_player_items
const HELMET : String = "HELMET"
const BODY : String = "BODY"
const BOOTS : String = "BOOTS"
const MAINHAND : String = "MAINHAND"
const OFFHAND : String = "OFFHAND"
const CONSUMABLE : String = "CONSUMABLE"

const LEFT : String = "LEFT"
const RIGHT : String = "RIGHT"

var player_items: Array = []
var player_consumables: Array = []
var player_helmet: Item
var player_body: Item
var player_boots: Item
var player_mainhand: Item
var player_offhand: Item

var currently_selected_tab: int

@onready var tab_bar: TabBar = $MarginContainer/Inventory/ItemContainer/MarginContainer/TabBar
@onready var item_grid: GridContainer = $MarginContainer/Inventory/ItemContainer/ItemPanel/ScrollContainer/ItemGrid

@onready var stat_container: HBoxContainer = $MarginContainer/Inventory/Right/StatContainer

@onready var head: GridContainer = $MarginContainer/Inventory/Right/Player/EquippedItemsMargin/EquipPanel/InsideMargin/VBoxContainer/HBoxContainer/Body/Head/Head
@onready var body: GridContainer = $MarginContainer/Inventory/Right/Player/EquippedItemsMargin/EquipPanel/InsideMargin/VBoxContainer/HBoxContainer/Body/Body/Body
@onready var feet: GridContainer = $MarginContainer/Inventory/Right/Player/EquippedItemsMargin/EquipPanel/InsideMargin/VBoxContainer/HBoxContainer/Body/Feet/Feet
@onready var mainhand: GridContainer = $MarginContainer/Inventory/Right/Player/EquippedItemsMargin/EquipPanel/InsideMargin/VBoxContainer/HBoxContainer/Hands/MainHand/MainHand
@onready var offhand: GridContainer = $MarginContainer/Inventory/Right/Player/EquippedItemsMargin/EquipPanel/InsideMargin/VBoxContainer/HBoxContainer/Hands/OffHand/OffHand

@export var inventory_item_scene: PackedScene
@export var equipped_item_scene: PackedScene

func _ready() -> void:
	hide()
	player_items = ItemManager.load_debug_items()
	_refresh_items()
	UiController.remove_consumable.connect(_remove_consumable)
	UiController.added_item_to_inventory.connect(_add_item_to_inventory)

func _refresh_items():
	sort_player_items()
	for inventory_item in item_grid.get_children():
		inventory_item.queue_free()
	
	for item in player_items:
		var inventory_item = inventory_item_scene.instantiate()
		inventory_item.item_hovered.connect(update_item_display)
		inventory_item.item_pressed.connect(activate_item)
		inventory_item.set_data(item)
		item_grid.add_child(inventory_item)
	
	for consumable in player_consumables:
		for item in player_items:
			if consumable.data.item_id == item.data.item_id:
				consumable.data.stack_size = item.data.stack_size
				break
	_on_tab_bar_tab_changed(currently_selected_tab)
	_emit_update_player_items()

func update_item_display(item: Item):
	stat_container.set_text(item)

func activate_item(inventory_item: InventoryItem, item: Item, mousebutton: String, _slot: String):
	match item.data.item_category:
		ItemData.ITEM_CATEGORY.WEAPON:
			equip_weapon(item, mousebutton, inventory_item, _slot)
		ItemData.ITEM_CATEGORY.ARMOR:
			pass
		ItemData.ITEM_CATEGORY.CONSUMABLE:
			equip_consumable(inventory_item, item)
		ItemData.ITEM_CATEGORY.MATERIAL:
			pass

func sort_player_items():
	player_items.sort_custom(sort_by_cat_and_name)

func sort_by_cat_and_name(a, b) -> bool:
	if a.data.item_category < b.data.item_category:
		return true
	elif a.data.item_category == b.data.item_category:
		if a.data.item_name < b.data.item_name:
			return true
	return false

func _on_tab_bar_tab_changed(tab: int) -> void:
	currently_selected_tab = tab
	match tab:
		0:
			for item in item_grid.get_children():
				item.show()
		1:
			change_displayed_tab(ItemData.ITEM_CATEGORY.WEAPON)
		2:
			change_displayed_tab(ItemData.ITEM_CATEGORY.ARMOR)
		3:
			change_displayed_tab(ItemData.ITEM_CATEGORY.CONSUMABLE)
		4:
			change_displayed_tab(ItemData.ITEM_CATEGORY.MATERIAL)

func change_displayed_tab(category: ItemData.ITEM_CATEGORY):
	for item in item_grid.get_children():
		if item.item.data.item_category == category:
			item.show()
		else:
			item.hide()

func equip_weapon(item: Item, mousebutton: String, pressed_inventory_item: InventoryItem, _pressed_slot: String = ""):
	var slot: String
	if mousebutton == LEFT or item.data.two_handed:
		slot = MAINHAND
	else:
		slot = OFFHAND
	
	_clear_previous_equipped_slot(slot, item, pressed_inventory_item)
	
	if item.data.equipped and _reequip_weapon_in_other_slot(item, pressed_inventory_item, mousebutton):
		unequip_item(pressed_inventory_item, item, "", pressed_inventory_item.slot)
	
	if not item.data.equipped:
		var inventory_item = equipped_item_scene.instantiate()
		inventory_item.item_hovered.connect(update_item_display)
		inventory_item.item_pressed.connect(unequip_item)
		item.data.equipped = true
		inventory_item.set_data(item, slot)
		pressed_inventory_item.set_data(item, slot)
		
		if item.data.two_handed:
			_remove_mainhand()
			_remove_offhand()
			player_mainhand = item
			player_offhand = null
			mainhand.add_child(inventory_item)
			var duplicate_item = inventory_item.duplicate()
			duplicate_item.disabled = true
			offhand.add_child(duplicate_item)
			UiController.update_hud_mainhand(player_mainhand)
			UiController.update_hud_offhand(player_mainhand, true)
		else:
			if mousebutton == LEFT:
				_remove_mainhand()
				if player_mainhand and player_mainhand.data.two_handed:
					_remove_offhand()
				if not player_offhand:
					_remove_offhand()
				player_mainhand = item
				mainhand.add_child(inventory_item)
				UiController.update_hud_mainhand(player_mainhand)
			else:
				if player_mainhand and player_mainhand.data.two_handed:
					_remove_mainhand()
				_remove_offhand()
				player_offhand = item
				offhand.add_child(inventory_item)
				UiController.update_hud_offhand(player_offhand, false)
		
		_emit_update_player_items()
	else:
		unequip_item(pressed_inventory_item, item, "", slot)

func _reequip_weapon_in_other_slot(item: Item, pressed_inventory_item: InventoryItem, mousebutton: String) -> bool:
	if item.data.two_handed:
		return false
	elif item.data.equipped and pressed_inventory_item.slot == MAINHAND and mousebutton == RIGHT:
		return true
	elif item.data.equipped and pressed_inventory_item.slot == OFFHAND and mousebutton == LEFT:
		return true
	else:
		return false

func _clear_previous_equipped_slot(slot: String, item: Item, _pressed_item: InventoryItem) -> void:
	for inventory_item in item_grid.get_children():
		var success: bool = false
		if item.data.item_id == inventory_item.item.data.item_id and inventory_item.item.data.equipped and _pressed_item == inventory_item:
			continue
		if inventory_item.item.data is WeaponData and inventory_item.item.data.two_handed and (inventory_item.slot == MAINHAND or inventory_item.slot == OFFHAND):
			success = true
		elif (item.data is WeaponData and item.data.two_handed and (inventory_item.slot == MAINHAND or inventory_item.slot == OFFHAND)):
			inventory_item.unequip()
			unequip_item(inventory_item, inventory_item.item, "", inventory_item.slot)
		elif inventory_item.slot == slot:
			success = true
		if success:
			inventory_item.unequip()
			unequip_item(inventory_item, inventory_item.item, "", inventory_item.slot)
			return

func unequip_item(_inventory_item: UIItem, item: Item, _mousebutton: String, slot: String):
	item.data.equipped = false
	var empty_slot: String = ""
	for iterated_inventory_item in item_grid.get_children():
		if item.data.item_id == iterated_inventory_item.item.data.item_id and slot == iterated_inventory_item.slot:
			iterated_inventory_item.set_data(item, empty_slot)
			break
	
	match item.data.item_category:
		ItemData.ITEM_CATEGORY.WEAPON:
			if slot == MAINHAND:
				_remove_mainhand()
				if item.data.two_handed:
					_remove_offhand()
			else:
				_remove_offhand()
		ItemData.ITEM_CATEGORY.ARMOR:
			pass
	_emit_update_player_items()

func _remove_mainhand():
	player_mainhand = null
	for child in mainhand.get_children():
		child.queue_free()
	UiController.update_hud_mainhand(null)

func _remove_offhand():
	player_offhand = null
	for child in offhand.get_children():
		child.queue_free()
	UiController.update_hud_offhand(null, false)

func equip_consumable(inventory_item: InventoryItem, item: Item):
	if not player_consumables.has(item):
		player_consumables.append(item)
		inventory_item.mark_consumable()
	else:
		player_consumables.remove_at(player_consumables.find(item))
		inventory_item.unmark_consumable()
	_emit_update_player_items()

func _remove_consumable(item: Item, remove_stack: bool):
	if remove_stack:
		for inventory_item in item_grid.get_children():
			if inventory_item.item.data.item_id == item.data.item_id:
				inventory_item.set_data(item)
				break
	else:
		for inventory_item in item_grid.get_children():
			if inventory_item.item.data.item_id == item.data.item_id:
				inventory_item.queue_free()
				break
		var remove_index: int = player_items.find(item)
		if remove_index:
			player_items.remove_at(remove_index)
		
		remove_index = player_consumables.find(item)
		if remove_index:
			player_consumables.remove_at(remove_index)

func _add_item_to_inventory(item: Item):
	var find_index: int = -1
	for i in range(player_items.size()):
		if player_items[i].data.item_id == item.data.item_id:
			find_index = i
			break
	if find_index == -1 or not item.data.stackable:
		player_items.append(item)
	else:
		player_items[find_index].data.stack_size += item.data.stack_size
		_refresh_items()

func _emit_update_player_items():
	UiController.update_player_consumables(player_consumables)
	update_player_items.emit(player_helmet,
		player_body,
		player_boots,
		player_mainhand,
		player_offhand,
	)

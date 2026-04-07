extends PanelContainer

signal update_player_items

var player_items: Array = []
var player_consumables: Array = []
var player_helmet: Item
var player_body: Item
var player_boots: Item
var player_mainhand: Item
var player_offhand: Item

@onready var tab_bar: TabBar = $MarginContainer/Inventory/ItemContainer/MarginContainer/TabBar
@onready var item_grid: GridContainer = $MarginContainer/Inventory/ItemContainer/ItemPanel/ItemGrid

@onready var weapon_text: ScrollContainer = $MarginContainer/Inventory/Right/StatContainer/ItemStatMargin/ItemPanel/_InsideMargin/WeaponScroller
@onready var consumable_text: ScrollContainer = $MarginContainer/Inventory/Right/StatContainer/ItemStatMargin/ItemPanel/_InsideMargin/ConsumableScroller

@onready var display_viewport: TextureRect = $MarginContainer/Inventory/Right/StatContainer/ItemDisplayMargin/DisplayPanel/_InsideMargin/DisplayViewport

@onready var head: GridContainer = $MarginContainer/Inventory/Right/Player/EquippedItemsMargin/EquipPanel/InsideMargin/VBoxContainer/HBoxContainer/Body/Head/Head
@onready var body: GridContainer = $MarginContainer/Inventory/Right/Player/EquippedItemsMargin/EquipPanel/InsideMargin/VBoxContainer/HBoxContainer/Body/Body/Body
@onready var feet: GridContainer = $MarginContainer/Inventory/Right/Player/EquippedItemsMargin/EquipPanel/InsideMargin/VBoxContainer/HBoxContainer/Body/Feet/Feet
@onready var mainhand: GridContainer = $MarginContainer/Inventory/Right/Player/EquippedItemsMargin/EquipPanel/InsideMargin/VBoxContainer/HBoxContainer/Hands/MainHand/MainHand
@onready var offhand: GridContainer = $MarginContainer/Inventory/Right/Player/EquippedItemsMargin/EquipPanel/InsideMargin/VBoxContainer/HBoxContainer/Hands/OffHand/OffHand

@export var inventory_item_scene: PackedScene

func _ready() -> void:
	hide()
	UiController.update_player_items.connect(_update_player_items)
	UiController.remove_consumable.connect(_remove_consumable)
	UiController.get_player_items.call_deferred()

func get_player_items():
	UiController.get_player_items()

func _update_player_items(updated_player_items: Array, updated_player_consumables: Array, _updated_player_helmet: Item, _updated_player_body: Item, _updated_player_boots: Item, _updated_player_mainhand: Item, _updated_player_offhand: Item) -> void:
	if not player_items == updated_player_items or not player_items:
		sort_player_items()
		player_items = updated_player_items
		
		for item in player_items:
			var inventory_item = inventory_item_scene.instantiate()
			inventory_item.item_hovered.connect(update_item_display)
			inventory_item.item_pressed.connect(activate_item)
			inventory_item.set_data(item)
			item_grid.add_child(inventory_item)
	#UiController.update_player_consumables(player_consumables)

func update_item_display(item: Item):
	match item.data.item_category:
		ItemData.ITEM_CATEGORY.WEAPON:
			weapon_text.show()
			consumable_text.hide()
			weapon_text.set_text(item)
		ItemData.ITEM_CATEGORY.CONSUMABLE:
			weapon_text.hide()
			consumable_text.show()
			consumable_text.set_text(item)
			
	display_viewport.texture = item.data.sprite

func activate_item(inventory_item: InventoryItem, item: Item, mousebutton: String, _slot: String):
	match item.data.item_category:
		ItemData.ITEM_CATEGORY.WEAPON:
			equip_weapon(item, mousebutton)
		ItemData.ITEM_CATEGORY.ARMOR:
			pass
		ItemData.ITEM_CATEGORY.CONSUMABLE:
			equip_consumable(inventory_item, item)
		ItemData.ITEM_CATEGORY.MATERIAL:
			pass

func sort_player_items():
	for i in range(player_items.size() - 1):
		for j in range(player_items.size() - 1):
			if player_items[i].data.item_category > player_items[j+1].data.item_category:
				var temp_item: Item = player_items[i].data.item_category
				player_items[i].data.item_category = player_items[j+1].data.item_category
				player_items[j+1].data.item_category = temp_item

func _on_tab_bar_tab_changed(tab: int) -> void:
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

func equip_weapon(item: Item, mousebutton: String):
	var inventory_item = inventory_item_scene.instantiate()
	inventory_item.item_hovered.connect(update_item_display)
	inventory_item.item_pressed.connect(unequip_item)
	inventory_item.set_data(item)
	
	if item.data.two_handed:
		_remove_mainhand()
		_remove_offhand()
		player_mainhand = item
		player_offhand = null
		inventory_item.set_slot("MAINHAND")
		mainhand.add_child(inventory_item)
		var duplicate_item = inventory_item.duplicate()
		duplicate_item.disabled = true
		offhand.add_child(duplicate_item)
	else:
		if mousebutton == "LEFT":
			_remove_mainhand()
			if not player_offhand:
				_remove_offhand()
			player_mainhand = item
			inventory_item.set_slot("MAINHAND")
			mainhand.add_child(inventory_item)
		else:
			_remove_offhand()
			player_offhand = item
			inventory_item.set_slot("OFFHAND")
			offhand.add_child(inventory_item)
	
	_emit_update_player_items()

func unequip_item(_inventory_item: InventoryItem, item: Item, _mousebutton: String, slot: String):
	match item.data.item_category:
		ItemData.ITEM_CATEGORY.WEAPON:
			if slot == "MAINHAND":
				_remove_mainhand()
				if item.data.two_handed:
					_remove_offhand()
			else:
				_remove_offhand()
		ItemData.ITEM_CATEGORY.ARMOR:
			pass

func _remove_mainhand():
	player_mainhand = null
	for child in mainhand.get_children():
		child.queue_free()

func _remove_offhand():
	player_offhand = null
	for child in offhand.get_children():
		child.queue_free()

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

func _emit_update_player_items():
	UiController.update_player_consumables(player_consumables)
	update_player_items.emit(player_items,
		player_consumables,
		player_helmet,
		player_body,
		player_boots,
		player_mainhand,
		player_offhand,
	)

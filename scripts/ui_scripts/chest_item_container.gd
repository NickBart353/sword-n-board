class_name ChestItemContainer extends VBoxContainer

@onready var chest_items: GridContainer = $InventorySplitter/ChestContainer/ChestSplitter/ScrollContainer/ChestItems
@onready var player_item_container: GridContainer = $InventorySplitter/PlayerContainer/PlayerSplitter/ScrollContainer/PlayerItems

@onready var inventory_item_scene: PackedScene = SceneManager.UIItemScenes.get("InventoryItem")
@onready var stat_container: HBoxContainer = $Tooltip/StatContainer

var loot_items: Array = []
var player_items: Array[Item] = []
var connected_container: ItemContainer

func _ready() -> void:
	UiController.returned_player_items.connect(_update_player_items)
	stat_container.hide()

func _update_player_items(new_player_items: Array[Item]) -> void:
	player_items = new_player_items as Array[Item]

func set_data(item_container: ItemContainer):
	connected_container = item_container
	loot_items = item_container.items
	_refresh_chest_items()

func _refresh_chest_items() -> void:
	for inventory_item in chest_items.get_children():
		inventory_item.queue_free()
	
	sort_items(loot_items)
	
	for item in loot_items:
		var inventory_item: InventoryItem = inventory_item_scene.instantiate()
		inventory_item.item_hovered.connect(update_item_display)
		inventory_item.item_pressed.connect(activate_item)
		inventory_item.item_unhovered.connect(clear_item_display)
		inventory_item.set_data(item)
		chest_items.add_child(inventory_item)
	
	_set_inventory_items()

func sort_items(items_to_sort: Array):
	items_to_sort.sort_custom(sort_by_cat_and_name)

func sort_by_cat_and_name(a: Item, b: Item) -> bool:
	if a.data.item_category < b.data.item_category:
		return true
	elif a.data.item_category == b.data.item_category:
		if a.data.item_name < b.data.item_name:
			return true
	return false

func update_player_item_display(item: Item) -> void:
	stat_container.set_text(item)
	stat_container.show()
	stat_container.global_position = get_position_of_item(item, "inventory")

func update_item_display(item: Item) -> void:
	stat_container.set_text(item)
	stat_container.show()
	stat_container.global_position = get_position_of_item(item, "chest")

func get_position_of_item(item: Item, inventory_type: String) -> Vector2:
	if inventory_type == "chest":
		for inventory_item in chest_items.get_children():
			if inventory_item.item.data.unique_id == item.data.unique_id:
				return inventory_item.global_position + Vector2(100, 100)
	elif inventory_type == "inventory":
		for inventory_item in player_item_container.get_children():
			if inventory_item.item.data.unique_id == item.data.unique_id:
				return inventory_item.global_position + Vector2(100, 100)
	return Vector2.ZERO

func clear_item_display() -> void:
	stat_container.hide()

func activate_item(inventory_item: InventoryItem, item: Item, _mousebutton: String, _slot: String) -> void:
	var success_checker_count: int = loot_items.size()
	loot_items.erase(item)
	if loot_items.size() == success_checker_count:
		print("Error while looting item: {0}".format(item.data.item_id))
	inventory_item.queue_free()
	connected_container.update_my_items(loot_items)
	UiController.add_item_to_inventory(item)

func _set_inventory_items() -> void:
	UiController.get_inventory_items()
	
	for player_item in player_item_container.get_children():
		player_item.queue_free()
	
	sort_items(player_items)
	
	for item in player_items:
		var inventory_item: InventoryItem = inventory_item_scene.instantiate()
		inventory_item.item_hovered.connect(update_player_item_display)
		inventory_item.item_unhovered.connect(clear_item_display)
		inventory_item.item_pressed.connect(activate_player_item)
		inventory_item.set_data(item)
		player_item_container.add_child(inventory_item)

func activate_player_item(inventory_item: InventoryItem, item: Item, _mousebutton: String, _slot: String) -> void:
	var success_checker_count: int = player_items.size()
	player_items.erase(item)
	if player_items.size() == success_checker_count:
		print("Error while looting item: {0}".format(item.data.item_id))
	inventory_item.queue_free()
	loot_items.append(item)
	connected_container.update_my_items(loot_items)
	UiController.remove_item_from_inventory(item)
	_refresh_chest_items()

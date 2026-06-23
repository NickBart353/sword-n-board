class_name ChestItemContainer extends HBoxContainer

@onready var chest_items: GridContainer = $ChestItems/ChestItems/PanelContainer/ScrollContainer/GridContainer
@onready var player_item_container: GridContainer = $PlayerItems/PlayerItems/PanelContainer/ScrollContainer/GridContainer
@onready var inventory_item_scene: PackedScene = SceneManager.UIItemScenes.get("InventoryItem")

var loot_items: Array = []
var player_items: Array[Item] = []
var connected_container: ItemContainer

func set_data(item_container: ItemContainer):
	connected_container = item_container
	for inventory_item in chest_items.get_children():
		inventory_item.queue_free()
	
	loot_items = item_container.items
	sort_items(loot_items)
	
	for item in loot_items:
		var inventory_item = inventory_item_scene.instantiate()
		inventory_item.item_hovered.connect(update_item_display)
		inventory_item.item_pressed.connect(activate_item)
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

func update_item_display(item: Item) -> void:
	pass#stat_container.set_text(item)

func activate_item(inventory_item: InventoryItem, item: Item, _mousebutton: String, _slot: String) -> void:
	var success_checker_count: int = loot_items.size()
	loot_items.erase(item)
	if loot_items.size() == success_checker_count:
		print("Error while looting item: {0}".format(item.data.item_id))
	inventory_item.queue_free()
	connected_container.update_my_items(loot_items)
	UiController.add_item_to_inventory(item)

func _set_inventory_items() -> void:
	var new_player_items: Array[Item] = UiController.get_inventory_items() as Array[Item]
	for player_item in player_item_container:
		player_item.queue_free()
	
	sort_items(new_player_items)
	
	for item in new_player_items:
		var inventory_item = inventory_item_scene.instantiate()
		inventory_item.item_hovered.connect(update_item_display)
		inventory_item.item_pressed.connect(activate_player_item)
		inventory_item.set_data(item)
		player_item_container.add_child(inventory_item)

func activate_player_item(inventory_item: InventoryItem, item: Item, _mousebutton: String, _slot: String) -> void:
	var success_checker_count: int = player_items.size()
	player_items.erase(item)
	if player_items.size() == success_checker_count:
		print("Error while looting item: {0}".format(item.data.item_id))
	inventory_item.queue_free()
	#UiController.add_item_to_inventory(item)
	#REMOVE ITEM FROM INVENTORY

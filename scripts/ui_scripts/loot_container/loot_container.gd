class_name LootContainer extends VBoxContainer

@onready var item_grid: GridContainer = $PanelContainer/VBoxContainer/ScrollContainer/ItemGrid
@onready var inventory_item_scene: PackedScene = SceneManager.UIItemScenes.get("InventoryItem")
@onready var stat_container: HBoxContainer = $StatContainer
@onready var enemy_name_label: Label = $PanelContainer/VBoxContainer/EnemyName

var loot_items: Array = []
var connected_container: ItemContainer

const loot_text: String = "{0} corpse"

func set_data(item_container: ItemContainer, enemy_name: String):
	enemy_name_label.text = loot_text.format([enemy_name])
	connected_container = item_container
	for inventory_item in item_grid.get_children():
		inventory_item.queue_free()
	
	loot_items = item_container.items
	sort_items()
	
	for item in loot_items:
		var inventory_item = inventory_item_scene.instantiate()
		inventory_item.item_hovered.connect(update_item_display)
		inventory_item.item_pressed.connect(activate_item)
		inventory_item.set_data(item)
		item_grid.add_child(inventory_item)

func sort_items():
	loot_items.sort_custom(sort_by_cat_and_name)

func sort_by_cat_and_name(a: Item, b: Item) -> bool:
	if a.data.item_category < b.data.item_category:
		return true
	elif a.data.item_category == b.data.item_category:
		if a.data.get_combined_name() < b.data.get_combined_name():
			return true
	return false

func update_item_display(item: Item) -> void:
	stat_container.set_text(item)

func activate_item(inventory_item: InventoryItem, item: Item, _mousebutton: String, _slot: String) -> void:
	var success_checker_count: int = loot_items.size()
	loot_items.erase(item)
	if loot_items.size() == success_checker_count:
		print("Error while looting item: {0}".format(item.data.item_id))
	inventory_item.queue_free()
	connected_container.update_my_items(loot_items)
	UiController.add_item_to_inventory(item)

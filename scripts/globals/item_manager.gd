extends Node

const ui_item_scene: PackedScene = preload("res://scenes/ui_scenes/item.tscn")
const action_sword_item_scene: PackedScene = preload("res://scenes/component_scenes/combat/weapons/sword.tscn")
const action_book_item_scene: PackedScene = preload("res://scenes/component_scenes/combat/weapons/book.tscn")

const ITEMS: Dictionary = {
	"health_potion": preload("res://resources/items/health_potion.tres"),
	"iron_sword": preload("res://resources/items/iron_sword.tres"),
	"wooden_shield": preload("res://resources/items/wooden_shield.tres"),
	"torch": preload("res://resources/items/torch.tres"),
	"magic_tome": preload("res://resources/items/magic_tome.tres"),
	"wooden_bow": preload("res://resources/items/bow.tres")
}

func generate_loot(_level):
	var items: Array = []
	for item_key in ITEMS.keys():
		if randf_range(0.0,1.0) <= ITEMS[item_key].drop_chance:
			var stacksize: int = 1
			if ITEMS[item_key].stackable:
				stacksize = randi_range(1,3)
			for counter in stacksize:
				var item_instance: Control = ui_item_scene.instantiate()
				item_instance.data = ITEMS[item_key]
				items.append(item_instance)
	return items

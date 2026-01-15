extends Node

const item_scene: PackedScene = preload("res://scenes/ui_scenes/item.tscn")

const ITEMS_ZERO_TO_FIVE: Dictionary = {
	"diamond_sword": preload("res://resources/items/diamond_sword.tres"),
	"iron_sword": preload("res://resources/items/iron_sword.tres"),
}

func _ready() -> void:
	pass

func generate_loot(_level):
	if randi_range(0,1) == 0:
		return []
	else:
		var items: Array = []
		for item in ITEMS_ZERO_TO_FIVE:
			var item_instance = item_scene.instantiate()
			item_instance.data = ITEMS_ZERO_TO_FIVE[item]
			items.append(item_instance)
		return items

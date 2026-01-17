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
		for i in range(9):
			var random_key = ITEMS_ZERO_TO_FIVE.keys().pick_random()
			var item_instance = item_scene.instantiate()
			item_instance.data = ITEMS_ZERO_TO_FIVE[random_key]
			items.append(item_instance)
		return items

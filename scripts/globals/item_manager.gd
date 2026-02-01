extends Node

const item_scene: PackedScene = preload("res://scenes/ui_scenes/item.tscn")

const ITEMS: Dictionary = {
	"health_potion": preload("res://resources/items/health_potion.tres"),
	"iron_sword": preload("res://resources/items/iron_sword.tres"),
	"wooden_shield": preload("res://resources/items/wooden_shield.tres"),
	"torch": preload("res://resources/items/torch.tres"),
}

func generate_loot(_level):
	if randi_range(0,1) == 0:
		return []
	else:
		var items: Array = []
		for item_key in ITEMS.keys():
			if randf_range(0.0,1.0) <= ITEMS[item_key].drop_chance:
				var stacksize: int = 1
				if ITEMS[item_key].stackable:
					stacksize = randi_range(1,3)
				for counter in stacksize:
					var item_instance: Control = item_scene.instantiate()
					item_instance.data = ITEMS[item_key]
					items.append(item_instance)
					print(item_instance.name)
		return items

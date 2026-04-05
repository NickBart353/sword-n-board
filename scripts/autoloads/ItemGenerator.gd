extends Node

enum SLOTS {MAIN_HAND, OFF_HAND}

const ITEM_TYPE_DICT: Dictionary = {
	ItemData.ITEM_TYPE.SWORD: preload("res://scenes/component_scenes/item_entities/weapons/sword.tscn"),
	ItemData.ITEM_TYPE.BOOK: {
		SLOTS.MAIN_HAND: preload("res://scenes/component_scenes/item_entities/weapons/book.tscn"),
		SLOTS.OFF_HAND: preload("res://scenes/VFX/magic_ball.tscn")
	},
	ItemData.ITEM_TYPE.BOW: preload("res://scenes/component_scenes/item_entities/weapons/bow.tscn"),
	ItemData.ITEM_TYPE.SHIELD: preload("res://scenes/component_scenes/item_entities/shield/shield.tscn"),
	ItemData.ITEM_TYPE.TORCH: preload("res://scenes/component_scenes/item_entities/torch/torch.tscn"),
	ItemData.ITEM_TYPE.POTION: preload("res://scenes/component_scenes/item_entities/consumable/health_potion.tscn")
}

const RESOURCE_DICT: Dictionary = {
	"405c2076-e86a-4c6d-8b9c-e48e4a16c317": preload("res://resources/items/health_potion.tres"),
	"0f955077-40b4-47d4-bb60-d0e8a7f73775": preload("res://resources/items/iron_sword.tres"),
	"8f767e0e-2df8-41e3-bc02-50d0e9147584": preload("res://resources/items/wooden_shield.tres"),
	"2de84977-0bb3-45b8-8ed1-ace14908b311": preload("res://resources/items/torch.tres"),
	"182471841": preload("res://resources/items/magic_tome.tres"),
	"12145426": preload("res://resources/items/bow.tres")
}

func generate_item(data: ItemData):
	var key = ITEM_TYPE_DICT.get(data.item_type)
	if not key:
		return null
	elif key is PackedScene:
		var item_instance = key.instantiate()
		item_instance.set_data(data)
		return item_instance
	elif key is Dictionary:
		var scenes: Dictionary = {}
		for slot in key:
			if key[slot] is PackedScene:
				var item_instance = key[slot].instantiate()
				if item_instance is ItemEntity:
					item_instance.set_data(data)
				scenes.set(slot, item_instance)
		return scenes

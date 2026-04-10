extends Node

enum SLOTS {MAIN_HAND, OFF_HAND}

const ITEM_TYPE_DICT: Dictionary = {
	ItemData.ITEM_TYPE.SHORTSWORD: preload("res://scenes/component_scenes/item_entities/weapons/sword.tscn"),
	ItemData.ITEM_TYPE.BOOK: {
		SLOTS.MAIN_HAND: preload("res://scenes/component_scenes/item_entities/weapons/book.tscn"),
		SLOTS.OFF_HAND: preload("res://scenes/VFX/magic_ball.tscn")
	},
	ItemData.ITEM_TYPE.BOW: preload("res://scenes/component_scenes/item_entities/weapons/bow.tscn"),
	ItemData.ITEM_TYPE.SHIELD: preload("res://scenes/component_scenes/item_entities/shield/shield.tscn"),
	ItemData.ITEM_TYPE.TORCH: preload("res://scenes/component_scenes/item_entities/torch/torch.tscn"),
	ItemData.ITEM_TYPE.POTION: preload("res://scenes/component_scenes/item_entities/consumable/health_potion.tscn"),
	#TEST ONLY -- REMOVE LATER
	ItemData.ITEM_TYPE.MANA_POTION: preload("res://scenes/component_scenes/item_entities/consumable/mana_potion.tscn")
	
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

extends Node

enum SLOTS {MAIN_HAND, OFF_HAND}

const ITEM_TYPE_DICT: Dictionary = {
	ItemData.ITEM_TYPE.SHORTSWORD: preload("res://scenes/component_scenes/item_entities/weapons/sword.tscn"),
	ItemData.ITEM_TYPE.BOOK: {
		SLOTS.MAIN_HAND: preload("res://scenes/component_scenes/item_entities/weapons/book.tscn"),
		SLOTS.OFF_HAND: preload("res://scenes/VFX/magic_ball.tscn")
	},
	ItemData.ITEM_TYPE.BOW: preload("res://scenes/component_scenes/item_entities/weapons/bow.tscn"),
	ItemData.ITEM_TYPE.SHIELD: preload("res://scenes/component_scenes/item_entities/weapons/shield/shield.tscn"),
	ItemData.ITEM_TYPE.TORCH: preload("res://scenes/component_scenes/item_entities/weapons/torch/torch.tscn"),
	ItemData.ITEM_TYPE.POTION: preload("res://scenes/component_scenes/item_entities/consumable/health_potion.tscn"),
	#TEST ONLY -- REMOVE LATER
	ItemData.ITEM_TYPE.MANA_POTION: preload("res://scenes/component_scenes/item_entities/consumable/mana_potion.tscn"),
	
}

const UNARMED: PackedScene = preload("res://scenes/component_scenes/item_entities/weapons/unarmed.tscn")
const UNARMED_DATA = preload("uid://b3qbpvnhs0ofq")

const MELEE_WEAPONS: Dictionary = {
	"10001": preload("res://scenes/component_scenes/item_entities/weapons/sword.tscn"),#shortsword
	"10004": preload("res://scenes/component_scenes/item_entities/weapons/greatsword.tscn"),#greatsword
	"10009": preload("res://scenes/component_scenes/item_entities/weapons/greataxe.tscn"),#greataxe
	"hatchet": "",
	"10005": preload("uid://cq5niuf135ca6"),#greathammer
	"katana": "",
	"spear": "",
	"10002": preload("res://scenes/component_scenes/item_entities/weapons/torch/torch.tscn"),#torch
	"10003": preload("res://scenes/component_scenes/item_entities/weapons/shield/shield.tscn"),#wooden_shield
	"dagger": "",
}

const RANGED_WEAPONS: Dictionary = {
	"30001": preload("res://scenes/component_scenes/item_entities/weapons/bow.tscn"),#shortbow
}

const MAGIC_WEAPONS: Dictionary = {
	"20001": preload("res://scenes/component_scenes/item_entities/weapons/book.tscn"),#maigc_tome
}

const CONSUMABLES: Dictionary = {
	"potion_scene": preload("uid://cm6r85odwjvkt"),
	"40001": preload("res://scenes/component_scenes/item_entities/consumable/health_potion.tscn"),#healthpotion
	"40002": preload("res://scenes/component_scenes/item_entities/consumable/mana_potion.tscn"),#manapotion
	"green_leaf": "",
	"rat_tooth": "",
	"bat_wing": "",
	"spider_blood": "",
	"fire_grenade": "",
}

func generate_unarmed() -> Node3D:
	var item_instance: Node3D = UNARMED.instantiate()
	item_instance.set_data(UNARMED_DATA)
	return item_instance

func generate_item(data: ItemData) -> Node3D:
	if not data:
		return null
	var item_instance: Node3D
	match data.item_sub_category:
		ItemData.ITEM_SUB_CATEGORY.MELEE_WEAPON:
			item_instance = MELEE_WEAPONS.get(data.item_id).instantiate()
		ItemData.ITEM_SUB_CATEGORY.RANGED_WEAPON:
			item_instance = RANGED_WEAPONS.get(data.item_id).instantiate()
		ItemData.ITEM_SUB_CATEGORY.MAGIC_WEAPON:
			item_instance = MAGIC_WEAPONS.get(data.item_id).instantiate()
		ItemData.ITEM_SUB_CATEGORY.CONSUMABLE:
			#item_instance = CONSUMABLES.get(data.item_id).instantiate()
			item_instance = CONSUMABLES.get("potion_scene").instantiate()
	item_instance.set_data(data)
	return item_instance

#func generate_item(data: ItemData):
	#var key = ITEM_TYPE_DICT.get(data.item_type)
	#if not key:
		#return null
	#elif key is PackedScene:
		#var item_instance = key.instantiate()
		#item_instance.set_data(data)
		#return item_instance
	#elif key is Dictionary:
		#var scenes: Dictionary = {}
		#for slot in key:
			#if key[slot] is PackedScene:
				#var item_instance = key[slot].instantiate()
				#if item_instance is ItemEntity:
					#item_instance.set_data(data)
				#scenes.set(slot, item_instance)
		#return scenes

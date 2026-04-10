extends Node

const ui_item_scene: PackedScene = preload("res://scenes/ui_scenes/item.tscn")

#const ITEMS: Dictionary = {
	#"health_potion": preload("res://resources/items/health_potion.tres"),
	#"mana_potion": preload("res://resources/items/mana_potion.tres"),
	#"MinorManaPotion" : preload("res://scenes/component_scenes/item_entities/consumable/mana_potion.tscn"),
	#"short_sword": preload("res://resources/items/short_sword.tres"),
	#"wooden_shield": preload("res://resources/items/wooden_shield.tres"),
	#"torch": preload("res://resources/items/torch.tres"),
	#"magic_tome": preload("res://resources/items/magic_tome.tres"),
	#"wooden_bow": preload("res://resources/items/bow.tres")
#}

const MELEE_WEAPONS: Dictionary = {
	"shortsword": preload("res://resources/items/melee_weapons/short_sword.tres"),
	"greatsword": "",
	"greataxe": "",
	"greathammer": "",
	"katana": "",
	"spear": "",
	"torch": preload("res://resources/items/melee_weapons/torch.tres"),
	"wooden_shield": preload("res://resources/items/melee_weapons/wooden_shield.tres"),
	"dagger": "",
}

const RANGED_WEAPONS: Dictionary = {
	"shortbow": preload("res://resources/items/ranged_weapons/bow.tres")
}

const MAGIC_WEAPONS: Dictionary = {
	"magic_tome": preload("res://resources/items/magic_weapons/magic_tome.tres"),
}

const CONSUMABLES: Dictionary = {
	"health_potion": preload("res://resources/items/consumables/health_potion.tres"),
	"mana_potion": preload("res://resources/items/consumables/mana_potion.tres"),
	"green_leaf": "",
	"rat_tooth": "",
	"bat_wing": "",
	"spider_blood": "",
	"fire_grenade": "",
}

const MATERIAL: Dictionary = {
	"small_upgrade_fragment": "",
	"medium_upgrade_fragment": "",
	"large_upgrade_fragment": "",
	"massive_upgrade_fragment": "",
	
	"small_fire": "",
	"small_lightning": "",
	"small_cold": "",
	"small_nature": "",
	"small_chaos": "",
	"large_fire": "",
	"large_lightning": "",
	"large_cold": "",
	"large_nature": "",
	"large_chaos": "",
}

const BASE_DROPTABLE: Dictionary = {
	"small_upgrade_fragment": {
		"drop_chance": 0.05,
		"max_amount": 2
	},
	"small_fire": {
		"drop_chance": 0.01,
		"max_amount": 1
	},
	"small_lightning":{
		"drop_chance": 0.01,
		"max_amount": 1
	},
	"small_cold":{
		"drop_chance": 0.01,
		"max_amount": 1
	},
	"small_nature":{
		"drop_chance": 0.01,
		"max_amount": 1
	},
	"small_chaos":{
		"drop_chance": 0.01,
		"max_amount": 1
	},
	"health_potion": {
		"drop_chance": 0.15,
		"max_amount": 3
	},
	"mana_potion": {
		"drop_chance": 0.1,
		"max_amount": 3
	},
	"green_leaf": {
		"drop_chance": 0.05,
		"max_amount": 1
	},
	"fire_grenade": {
		"drop_chance": 0.05,
		"max_amount": 1
	},
}

const MID_LEVEL_DROPTABLE: Dictionary = {
	BASE_DROPTABLE: "DOUBLE",
	"medium_upgrade_fragment":{
		"drop_chance": 0.05,
		"max_amount": 2
	},
}

const HIGH_LEVEL_DROPTABLE: Dictionary = {
	BASE_DROPTABLE: "DOUBLE",
	"medium_upgrade_fragment":{
		"drop_chance": 0.1,
		"max_amount": 2
	},
	"large_upgrade_fragment": {
		"drop_chance": 0.05,
		"max_amount": 2
	},
	"massive_upgrade_fragment": {
		"drop_chance": 0.01,
		"max_amount": 2
	},
	"large_fire": {
		"drop_chance": 0.01,
		"max_amount": 1
	},
	"large_lightning": {
		"drop_chance": 0.01,
		"max_amount": 1
	},
	"large_cold": {
		"drop_chance": 0.01,
		"max_amount": 1
	},
	"large_nature": {
		"drop_chance": 0.01,
		"max_amount": 1
	},
	"large_chaos": {
		"drop_chance": 0.01,
		"max_amount": 1
	},
}

func generate_loot(level: int, additional_drop_keys: Dictionary = {}):
	var dict_to_take_from: Dictionary
	if level < 15:
		dict_to_take_from = BASE_DROPTABLE
	elif level < 30:
		dict_to_take_from = MID_LEVEL_DROPTABLE
	else:
		dict_to_take_from = HIGH_LEVEL_DROPTABLE
	
	var items: Array = []
	for item_key in dict_to_take_from.keys():
		if item_key is Dictionary:
			var multiplier: float = 1.0
			match dict_to_take_from[item_key]:
				"DOUBLE":
					multiplier = 2.0
			for sub_item_key in item_key:
				var new_item: Control = get_item(item_key, dict_to_take_from[item_key]["drop_chance"] * multiplier, dict_to_take_from[item_key]["max_amount"])
				if new_item:
					items.append(new_item)
		elif item_key is String:
			var new_item: Control = get_item(item_key, dict_to_take_from[item_key]["drop_chance"], dict_to_take_from[item_key]["max_amount"])
			if new_item:
				items.append(new_item)
	for item_key in additional_drop_keys:
		var new_item: Control = get_item(item_key, dict_to_take_from[item_key]["drop_chance"], dict_to_take_from[item_key]["max_amount"])
		if new_item:
			items.append(new_item)
	return items

func get_item(key: String, drop_chance: float, stack_amount: int) -> Control:
	if randf_range(0.0,1.0) <= drop_chance:
		var stacksize: int = randi_range(1, stack_amount)
		var item_data: ItemData
		var item_instance: Control = ui_item_scene.instantiate()
		if MELEE_WEAPONS.get(key):
			item_data = MELEE_WEAPONS[key]
		elif RANGED_WEAPONS.get(key):
			item_data = RANGED_WEAPONS[key]
		elif MAGIC_WEAPONS.get(key):
			item_data = MAGIC_WEAPONS[key]
		elif CONSUMABLES.get(key):
			item_data = CONSUMABLES[key]
		elif MATERIAL.get(key):
			item_data = MATERIAL[key]
		if not item_data:
			print("Data not found for: {0} - {1}".format([item_instance, key]))
			return null
		else:
			if item_data.stackable:
				item_data.stack_size = stacksize
		item_instance.data = item_data
		return item_instance
	return null

func load_debug_items() -> Array:
	var items: Array = []
	for item_key in MELEE_WEAPONS:
		var new_item: Control = get_item(item_key, 1, 5)
		if new_item:
			items.append(new_item)
	for item_key in RANGED_WEAPONS:
		var new_item: Control = get_item(item_key, 1, 5)
		if new_item:
			items.append(new_item)
	for item_key in MAGIC_WEAPONS:
		var new_item: Control = get_item(item_key, 1, 5)
		if new_item:
			items.append(new_item)
	for item_key in CONSUMABLES:
		var new_item: Control = get_item(item_key, 1, 5)
		if new_item:
			items.append(new_item)
	for item_key in MATERIAL:
		var new_item: Control = get_item(item_key, 1, 5)
		if new_item:
			items.append(new_item)
	return items

#func generate_loot(_level):
	#var items: Array = []
	#for item_key in ITEMS.keys():
		#if randf_range(0.0,1.0) <= ITEMS[item_key].drop_chance:
			#var stacksize: int = 1
			#if ITEMS[item_key].stackable:
				#stacksize = randi_range(1,3)
			#for counter in stacksize:
				#var item_instance: Control = ui_item_scene.instantiate()
				#item_instance.data = ITEMS[item_key]
				#items.append(item_instance)
	#return items

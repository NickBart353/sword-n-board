extends Node

var debug: bool = true

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

const MELEE_WEAPONS: Dictionary = {#weapon resources
	"10001" : preload("res://resources/items/melee_weapons/short_sword.tres"), #shortsword
	"10004" : preload("uid://qpdw7kpnlexp"), #greatsword
	"10009" : preload("uid://dsjivk0hqdt2w"), #greataxe
	"10007" : preload("uid://cxr6fc77pudua"), #hatchet
	"10005" : preload("uid://bcahgjv4glvrm"), #greathammer
	"10010" : preload("uid://cln5hv1qcq4ll"), #katana
	"10008" : preload("uid://bovbahtw7dtub"), #spear
	"10002" : preload("res://resources/items/melee_weapons/torch.tres"), #torch
	"10003" : preload("res://resources/items/melee_weapons/wooden_shield.tres"), #wooden_shield
	"10011" : preload("uid://bbn7q72ym8sio"), #hammer
	"10006" : preload("uid://d1inafjkmbrho"), #dagger
}

const RANGED_WEAPONS: Dictionary = {
	"30001" : preload("res://resources/items/ranged_weapons/bow.tres") #shortbow
}

const MAGIC_WEAPONS: Dictionary = {
	"20001" : preload("res://resources/items/magic_weapons/magic_tome.tres"), #magic_tome
}

const CONSUMABLES: Dictionary = {
	"40001": preload("res://resources/items/consumables/minor_health_potion.tres"), #minor_health_potion
	"40004": preload("res://resources/items/consumables/minor_mana_potion.tres"), #minor_mana_potion
	"40002": preload("res://resources/items/consumables/health_potion.tres"), #health_potion
	"40005": preload("res://resources/items/consumables/mana_potion.tres"), #mana_potion
	"40003": preload("res://resources/items/consumables/major_health_potion.tres"), #major_health_potion
	"40006": preload("res://resources/items/consumables/major_mana_potion.tres"), #major_mana_potion
	"40007": preload("uid://c6rg8eaeuxc5w"), #green_leaf
	"rat_tooth": "",
	"bat_wing": "",
	"spider_blood": "",
	"fire_grenade": "",
}

const MATERIAL: Dictionary = {
	"small_upgrade_fragment": preload("uid://cu14hpnk5pru"),
	"medium_upgrade_fragment": preload("uid://bburj521tlqiy"),
	"large_upgrade_fragment": preload("uid://d3ro71qa6lcdy"),
	"massive_upgrade_fragment": preload("uid://hi0sh3roww7k"),
	
	"small_fire": preload("uid://jlv2epo5gglj"),
	"small_lightning": preload("uid://ckmfb1xefgy6u"),
	"small_cold": preload("uid://d1quidydrljqr"),
	"small_nature": preload("uid://iak0iw4x0cdp"),
	"small_chaos": preload("uid://dcnixd1d4orvf"),
	"large_fire": preload("uid://dhf6iqjep7ffq"),
	"large_lightning": preload("uid://d0kg5j8bdr7ix"),
	"large_cold": preload("uid://772uumedashc"),
	"large_nature": preload("uid://boypt4wyawuij"),
	"large_chaos": preload("uid://dxo3kkiumamju"),
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

func get_item_from_id(item_id: String) -> Item:
	var item_instance: Item = ui_item_scene.instantiate()
	print("id: ", item_id)
	if MELEE_WEAPONS.get(item_id) != null:
		return _get_item_data(MELEE_WEAPONS[item_id], item_instance)
	if CONSUMABLES.get(item_id) != null:
		return _get_item_data(CONSUMABLES[item_id], item_instance)
	if RANGED_WEAPONS.get(item_id) != null:
		return _get_item_data(RANGED_WEAPONS[item_id], item_instance)
	if MAGIC_WEAPONS.get(item_id) != null:
		return _get_item_data(MAGIC_WEAPONS[item_id], item_instance)
	if MATERIAL.get(item_id) != null:
		return _get_item_data(MATERIAL[item_id], item_instance)
	return null

func _get_item_data(resource: Resource, item_instance: Item) -> Item:
	var item_data: ItemData
	item_data = resource
	item_instance.data = item_data.duplicate(true)
	return item_instance

func generate_loot(_level: int, _additional_drop_keys: Dictionary = {}):
	#var dict_to_take_from: Dictionary
	#if level < 15:
		#dict_to_take_from = BASE_DROPTABLE
	#elif level < 30:
		#dict_to_take_from = MID_LEVEL_DROPTABLE
	#else:
		#dict_to_take_from = HIGH_LEVEL_DROPTABLE
	#
	var items: Array = []
	var _item_instance: Item = ui_item_scene.instantiate()
	
	var randi: int = randi_range(0, MELEE_WEAPONS.size() - 1)
	var counter: int = 0
	for key in MELEE_WEAPONS:
		if counter == randi:
			items.append(get_item_from_id(key))
			break
		counter += 1
	
	randi = randi_range(0, CONSUMABLES.size() - 1)
	counter = 0
	for key in CONSUMABLES:
		if counter == randi:
			items.append(get_item_from_id(key))
			break
		counter += 1
	
	randi = randi_range(0, MATERIAL.size() - 1)
	counter = 0
	for key in MATERIAL:
		if counter == randi:
			items.append(get_item_from_id(key))
			break
		counter += 1
	#for item_key in dict_to_take_from.keys():
		#if item_key is Dictionary:
			#var multiplier: float = 1.0
			#match dict_to_take_from[item_key]:
				#"DOUBLE":
					#multiplier = 2.0
			#for sub_item_key in item_key:
				#var new_item: Control = get_item(item_key, dict_to_take_from[item_key]["drop_chance"] * multiplier, dict_to_take_from[item_key]["max_amount"])
				#if new_item:
					#items.append(new_item)
		#elif item_key is String:
			#var new_item: Control = get_item(item_key, dict_to_take_from[item_key]["drop_chance"], dict_to_take_from[item_key]["max_amount"])
			#if new_item:
				#items.append(new_item)
	#for item_key in additional_drop_keys:
		#var new_item: Control = get_item(item_key, dict_to_take_from[item_key]["drop_chance"], dict_to_take_from[item_key]["max_amount"])
		#if new_item:
			#items.append(new_item)
	return items

func get_item(key: String, drop_chance: float, stack_amount: int) -> Item:
	if randf_range(0.0,1.0) <= drop_chance or debug:
		var stacksize: int = randi_range(1, stack_amount)
		var item_data: ItemData
		var item_instance: Item = ui_item_scene.instantiate()
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
			item_data = item_data.duplicate()
			if item_data.stackable:
				item_data.stack_size = stacksize
		item_instance.data = item_data
		return item_instance
	return null

func load_debug_items() -> Array:
	var items: Array = []
	for i in range(2):
		for item_key in MELEE_WEAPONS:
			var new_item: Item = get_item(item_key, 1, 5)
			if new_item:
				items.append(new_item)
		#for item_key in RANGED_WEAPONS:
			#var new_item: Item = get_item(item_key, 1, 5)
			#if new_item:
				#items.append(new_item)
		#for item_key in MAGIC_WEAPONS:
			#var new_item: Item = get_item(item_key, 1, 5)
			#if new_item:
				#items.append(new_item)
	for item_key in CONSUMABLES:
		var new_item: Item = get_item(item_key, 1, 5)
		if new_item:
			items.append(new_item)
	#for item_key in MATERIAL:
		#var new_item: Item = get_item(item_key, 1, 5)
		#if new_item:
			#items.append(new_item)
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

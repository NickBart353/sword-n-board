extends Node

var debug: bool = true

const ui_item_scene: PackedScene = preload("res://scenes/ui_scenes/item.tscn")

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
	#"40004": preload("res://resources/items/consumables/minor_mana_potion.tres"), #minor_mana_potion
	"40002": preload("res://resources/items/consumables/health_potion.tres"), #health_potion
	#"40005": preload("res://resources/items/consumables/mana_potion.tres"), #mana_potion
	"40003": preload("res://resources/items/consumables/major_health_potion.tres"), #major_health_potion
	#"40006": preload("res://resources/items/consumables/major_mana_potion.tres"), #major_mana_potion
	"40007": preload("uid://c6rg8eaeuxc5w"), #green_leaf
	#"rat_tooth": "",
	#"bat_wing": "",
	#"spider_blood": "",
	#"fire_grenade": "",
}

const MATERIAL: Dictionary = {
	"50001": preload("uid://cu14hpnk5pru"), #small_upgrade_fragment
	"50002": preload("uid://bburj521tlqiy"), #medium_upgrade_fragment
	"50003": preload("uid://d3ro71qa6lcdy"), #large_upgrade_fragment
	"50004": preload("uid://hi0sh3roww7k"), #massive_upgrade_fragment
	
	"50007": preload("uid://jlv2epo5gglj"), #small_fire
	"50011": preload("uid://ckmfb1xefgy6u"), #small_lightning
	"50009": preload("uid://d1quidydrljqr"), #small_cold
	"50005": preload("uid://iak0iw4x0cdp"), #small_nature
	"50013": preload("uid://dcnixd1d4orvf"), #small_chaos
	"50008": preload("uid://dhf6iqjep7ffq"), #large_fire
	"50012": preload("uid://d0kg5j8bdr7ix"), #large_lightning
	"50010": preload("uid://772uumedashc"), #large_cold
	"50006": preload("uid://boypt4wyawuij"), #large_nature
	"50014": preload("uid://dxo3kkiumamju"), #large_chaos
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

func get_item_from_id(item_id: String, existing_itemdata: ItemData = null) -> Item:
	if item_id.is_empty() or item_id == null:
		push_error("id null or empty")
		return null
	
	var item_instance: Item = ui_item_scene.instantiate()
	var new_itemdata: ItemData
	if MELEE_WEAPONS.has(item_id):
		new_itemdata = MELEE_WEAPONS[item_id]
	if CONSUMABLES.has(item_id):
		new_itemdata = CONSUMABLES[item_id]
	if RANGED_WEAPONS.has(item_id):
		new_itemdata = RANGED_WEAPONS[item_id]
	if MAGIC_WEAPONS.has(item_id):
		new_itemdata = MAGIC_WEAPONS[item_id]
	if MATERIAL.has(item_id):
		new_itemdata = MATERIAL[item_id]
	
	if new_itemdata == null:
		push_error("invalid id")
		return null
	
	new_itemdata = new_itemdata.duplicate(true)
	
	fill_itemdata(new_itemdata, existing_itemdata)
	item_instance.data = new_itemdata
	return item_instance

func fill_itemdata(itemdata: ItemData, existing_itemdata: ItemData = null):
	if existing_itemdata:
		itemdata.item_name = existing_itemdata.item_name
		itemdata.prefix = existing_itemdata.prefix
		itemdata.suffix = existing_itemdata.suffix
		itemdata.unique_id = existing_itemdata.unique_id
		itemdata.stack_size = existing_itemdata.stack_size
		itemdata.equipped = existing_itemdata.equipped
		
		if itemdata is WeaponData:
			itemdata.upgrade_type = existing_itemdata.upgrade_type
			itemdata.upgrade_level = existing_itemdata.upgrade_level
	else:
		itemdata.unique_id = UuidGenerator.uuid4()
	if itemdata is WeaponData:
		create_damage_resource(itemdata)

#func _get_item_from_id(item_id: String, itemdata: ItemData = null) -> Item:
	#var item_instance: Item = ui_item_scene.instantiate()
	#if MELEE_WEAPONS.get(item_id) != null:
		#item_instance = _get_item_from_new_resource(MELEE_WEAPONS[item_id], item_instance)
		#item_instance = create_upgraded_weapon_from_id(item_instance.data.upgrade_type, item_instance.data.item_id)
		##item_instance.data = create_upgraded_version_from_resource(item_instance.data)
		#return item_instance
	#if CONSUMABLES.get(item_id) != null:
		#return _get_item_from_new_resource(CONSUMABLES[item_id], item_instance)
	#if RANGED_WEAPONS.get(item_id) != null:
		#return _get_item_from_new_resource(RANGED_WEAPONS[item_id], item_instance)
	#if MAGIC_WEAPONS.get(item_id) != null:
		#return _get_item_from_new_resource(MAGIC_WEAPONS[item_id], item_instance)
	#if MATERIAL.get(item_id) != null:
		#return _get_item_from_new_resource(MATERIAL[item_id], item_instance)
	#return null

func get_item_from_existing_itemdata(itemdata: ItemData) -> Item:
	if not itemdata:
		return null
	var item_instance: Item = get_item_from_id(itemdata.item_id, itemdata)
	return item_instance

#func _get_item_from_new_resource(resource: Resource, item_instance: Item) -> Item:
	#var item_data: ItemData
	#item_data = resource
	#item_instance.data = item_data.duplicate(true)
	#item_data.unique_id = UuidGenerator.uuid4()
	#if resource is WeaponData:
		#item_instance.data = create_upgraded_version_from_resource(item_instance.data)
	#return item_instance

#func create_upgraded_weapon_from_id(type: WeaponData.UPGRADE_TYPE, item_id: String) -> Item:
	#var item_instance: Item = ui_item_scene.instantiate()
	#if MELEE_WEAPONS.has(item_id):
		#item_instance = _get_item_from_new_resource(MELEE_WEAPONS[item_id], item_instance)
	#else:
		#push_error("failed to instantiate item for id: ", item_id, " upgrade type: ", type)
		#return null
	#
	#var name_prefix: String = WeaponData.get_upgrade_type_name_prefix(type)
	#if name_prefix != "" and not item_instance.data.item_name.contains(name_prefix):
		#item_instance.data.item_name = "{0} {1}".format([name_prefix, item_instance.data.item_name])
		#var new_sprite: Texture2D = WeaponData.get_upgrade_type_sprite(item_instance.data.item_name)
		#if new_sprite != null:
			#item_instance.data.sprite = new_sprite
	#
	#return item_instance
#
#func create_upgraded_version_from_resource(item_resource: WeaponData) -> WeaponData:
	#var name_prefix: String = WeaponData.get_upgrade_type_name_prefix(item_resource.upgrade_type)
	##prints("prefix", name_prefix, "type", item_resource.upgrade_type)
	#create_damage_resource(item_resource)
	#if name_prefix != "" and not item_resource.item_name.contains(name_prefix):
		#item_resource.item_name = "{0} {1}".format([name_prefix, item_resource.item_name])
		#var new_sprite: Texture2D = WeaponData.get_upgrade_type_sprite(item_resource.item_name)
		#if new_sprite != null:
			#item_resource.sprite = new_sprite
		#
	#return item_resource

func create_damage_resource(item_resource: WeaponData) -> void:
	var type: WeaponData.UPGRADE_TYPE = item_resource.upgrade_type
	var container: DamageContainer = DamageContainer.new()
	match type:
		WeaponData.UPGRADE_TYPE.NORMAL, WeaponData.UPGRADE_TYPE.CHAOS:
			var damage_resource: DamageResource = DamageResource.new()
			damage_resource.damage_type = type
			damage_resource.damage_amount = item_resource.single_base_damage + (item_resource.single_base_incrementor * item_resource.upgrade_level)
			container.primary_damage = damage_resource
		WeaponData.UPGRADE_TYPE.FIRE, WeaponData.UPGRADE_TYPE.COLD, WeaponData.UPGRADE_TYPE.LIGHTNING, WeaponData.UPGRADE_TYPE.NATURE:
			var primary_damage_resource: DamageResource = DamageResource.new()
			primary_damage_resource.damage_type = type
			primary_damage_resource.damage_amount = item_resource.hybrid_elemental_base_damage + (item_resource.hybrid_elemental_base_incrementor * item_resource.upgrade_level)
			container.primary_damage = primary_damage_resource
			
			var secondary_damage_resource: DamageResource = DamageResource.new()
			secondary_damage_resource.damage_type = WeaponData.UPGRADE_TYPE.NORMAL
			secondary_damage_resource.damage_amount = item_resource.hybrid_normal_base_damge + (item_resource.hybrid_normal_base_incrementor * item_resource.upgrade_level)
			container.additional_damage.append(secondary_damage_resource)
			
	item_resource.damage_container = container
	apply_damage_text(item_resource)

func apply_damage_text(item_resource: WeaponData) -> void:
	item_resource.normal_text = "0"
	item_resource.fire_text = "0"
	item_resource.cold_text = "0"
	item_resource.lightning_text = "0"
	item_resource.nature_text = "0"
	item_resource.chaos_text = "0"
	
	apply_text_to_damage_type(item_resource, item_resource.damage_container.primary_damage)
	
	for damage_resource in item_resource.damage_container.additional_damage:
		apply_text_to_damage_type(item_resource, damage_resource)

func apply_text_to_damage_type(item_resource: WeaponData, damage_resource: DamageResource) -> void:
	match damage_resource.damage_type:
		WeaponData.UPGRADE_TYPE.NORMAL:
			item_resource.normal_text = str(damage_resource.damage_amount)
		WeaponData.UPGRADE_TYPE.FIRE:
			item_resource.fire_text = str(damage_resource.damage_amount)
		WeaponData.UPGRADE_TYPE.COLD:
			item_resource.cold_text = str(damage_resource.damage_amount)
		WeaponData.UPGRADE_TYPE.LIGHTNING:
			item_resource.lightning_text = str(damage_resource.damage_amount)
		WeaponData.UPGRADE_TYPE.NATURE:
			item_resource.nature_text = str(damage_resource.damage_amount)
		WeaponData.UPGRADE_TYPE.CHAOS:
			item_resource.chaos_text = str(damage_resource.damage_amount)

func generate_loot(_level: int, _additional_drop_keys: Dictionary = {}):
	var items: Array = []
	var _item_instance: Item = ui_item_scene.instantiate()
	
	if is_successful(0.01):
		var item_id: String = MELEE_WEAPONS.keys().pick_random()
		items.append(get_item_from_id(item_id))
	
	if is_successful(0.30):
		var consumable_keys: Array[String]
		consumable_keys.assign(CONSUMABLES.keys())
		var amount_of_different_consumables = randi_range(1, consumable_keys.size())
		var picked_ids: Array[String] = []
		for i in amount_of_different_consumables:
			var consumable_id: String = consumable_keys.pick_random()
			while picked_ids.has(consumable_id):
				consumable_id = consumable_keys.pick_random()
			picked_ids.append(consumable_id)
			var item: Item = get_item_from_id(consumable_id)
			if item.data.stackable:
				item.data.stack_size = randi_range(1, 3)
			items.append(item)
	return items

func is_successful(chance_float: float) -> bool:
	return randf_range(0.0, 1.0) <= chance_float

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

### DEBUG ###

func get_all_upgrade_types_for_all_items() -> Array[Item]:
	var items: Array[Item] = []
	for id in MELEE_WEAPONS:
		items.append_array(get_all_upgrade_types_for_id(id))
	return items

func level_up_weapon(item: Item) -> Item:
	item.data.upgrade_level += 1
	item.data.suffix = " +{0}".format([item.data.upgrade_level])
	create_damage_resource(item.data)
	return item

func upgrade_weapon(item: Item, upgrade_type: WeaponData.UPGRADE_TYPE) -> Item:
	item.data.upgrade_type = upgrade_type
	var name_prefix: String = WeaponData.get_upgrade_type_name_prefix(upgrade_type)
	if name_prefix != "" and not item.data.item_name.contains(name_prefix):
		item.data.prefix = name_prefix
		var new_sprite: Texture2D = WeaponData.get_upgrade_type_sprite(item.data.item_name)
		if new_sprite != null:
			item.data.sprite = new_sprite
	create_damage_resource(item.data)
	return item

func get_all_upgrade_types_for_id(id: String) -> Array[Item]:
	if not MELEE_WEAPONS.has(id):
		push_error("failed to load debug items for: ", id)
		return []
	var items: Array[Item] = []
	var normal: Item = ItemManager.get_item_from_id(id)
	upgrade_weapon(normal, WeaponData.UPGRADE_TYPE.NORMAL)
	level_up_weapon(normal)
	level_up_weapon(normal)
	level_up_weapon(normal)
	level_up_weapon(normal)
	level_up_weapon(normal)
	level_up_weapon(normal)
	items.append(normal)
	var fire: Item = ItemManager.get_item_from_id(id)
	upgrade_weapon(fire, WeaponData.UPGRADE_TYPE.FIRE)
	items.append(fire)
	var cold: Item = ItemManager.get_item_from_id(id)
	upgrade_weapon(cold, WeaponData.UPGRADE_TYPE.COLD)
	items.append(cold)
	var lighting: Item = ItemManager.get_item_from_id(id)
	upgrade_weapon(lighting, WeaponData.UPGRADE_TYPE.LIGHTNING)
	items.append(lighting)
	var nature: Item = ItemManager.get_item_from_id(id)
	upgrade_weapon(nature, WeaponData.UPGRADE_TYPE.NATURE)
	items.append(nature)
	var chaos: Item = ItemManager.get_item_from_id(id)
	upgrade_weapon(chaos, WeaponData.UPGRADE_TYPE.CHAOS)
	items.append(chaos)

	return items
 

class_name ItemData
extends Resource

@export var item_name: String
@export var item_id: String
@export_multiline var tooltip: String
@export_multiline var explanation_text: String
@export var stackable: bool = false
@export var sprite: Texture2D
@export var drop_chance: float
@export var mesh: Mesh
@export var item_category: ITEM_CATEGORY
@export var item_sub_category: ITEM_SUB_CATEGORY
@export var item_type: ITEM_TYPE

@export var stack_size: int = 1

@export var unique_id: String

var equipped: bool = false
var prefix: String = ""
var suffix: String = ""

enum ITEM_CATEGORY {WEAPON, ARMOR, CONSUMABLE, MATERIAL}
enum ITEM_SUB_CATEGORY {MELEE_WEAPON, RANGED_WEAPON, MAGIC_WEAPON, CONSUMABLE, THROWABLE, MATERIAL}
enum ITEM_TYPE {SHORTSWORD, GREATSWORD, AXE, GREATAXE, DAGGER, HAMMER, GREATHAMMER, KATANA, SPEAR, TORCH, 
				SHIELD, GREATSHIELD, FIST,
				BOOK, WAND, STAFF, MAGIC_HAND,
				BOW, GREATBOW,
				POTION, MANA_POTION, CONSUMABLE, GRENADE, THROWING_KNIFE,
				UPGRADE_SHARD, TRANSFORM_SHARD,
				}

func get_combined_name() -> String:
	return "{0}{1}{2}".format([prefix, item_name, suffix])

static func get_item_category_value(value: ITEM_CATEGORY) -> String:
	match value:
		ITEM_CATEGORY.WEAPON:
			return "Weapon"
		ITEM_CATEGORY.ARMOR:
			return "Armor"
		ITEM_CATEGORY.CONSUMABLE:
			return "Consumable"
		ITEM_CATEGORY.MATERIAL:
			return "Material"
	return "Wrong category or forgot adding name to item_resource.gd"

static func get_item_sub_category_value(value: ITEM_SUB_CATEGORY) -> String:
	match value:
		ITEM_SUB_CATEGORY.MELEE_WEAPON:
			return "Melee Weapon"
		ITEM_SUB_CATEGORY.RANGED_WEAPON:
			return "Ranged Weapon"
		ITEM_SUB_CATEGORY.MAGIC_WEAPON:
			return "Magic Weapon"
		ITEM_SUB_CATEGORY.CONSUMABLE:
			return "Consumable"
		ITEM_SUB_CATEGORY.THROWABLE:
			return "Throwable"
		ITEM_SUB_CATEGORY.MATERIAL:
			return "Material"
	return "Wrong sub-category or forgot adding name to item_resource.gd"

static func get_item_type_value(value: ITEM_TYPE) -> String:
	match value:
		ITEM_TYPE.SHORTSWORD:
			return "Shortsword"
		ITEM_TYPE.GREATSWORD:
			return "Greatsword"
		ITEM_TYPE.AXE:
			return "Axe"
		ITEM_TYPE.GREATAXE:
			return "Greataxe"
		ITEM_TYPE.DAGGER:
			return "Dagger"
		ITEM_TYPE.GREATHAMMER:
			return "Greathammer"
		ITEM_TYPE.HAMMER:
			return "Hammer"
		ITEM_TYPE.KATANA:
			return "Katana"
		ITEM_TYPE.SPEAR:
			return "Spear"
		ITEM_TYPE.FIST:
			return "Fist"
		ITEM_TYPE.BOOK:
			return "Book"
		ITEM_TYPE.BOW:
			return "Bow"
		ITEM_TYPE.POTION:
			return "Potion"
		ITEM_TYPE.GRENADE:
			return "Grenade"
		ITEM_TYPE.CONSUMABLE:
			return "Consumable"
		ITEM_TYPE.TORCH:
			return "Torch"
		ITEM_TYPE.SHIELD:
			return "Shield"
		ITEM_TYPE.UPGRADE_SHARD:
			return "Upgrade shard"
		ITEM_TYPE.TRANSFORM_SHARD:
			return "Transform shard"
	return "Wrong type or forgot adding name to item_resource.gd"

static func get_itemtype_animation_name(type: ITEM_TYPE) -> String:
	match type:
		ITEM_TYPE.SHORTSWORD:
			return "shortsword"
		ITEM_TYPE.GREATSWORD:
			return "greatsword"
		ITEM_TYPE.AXE:
			return "hatchet"
		ITEM_TYPE.GREATAXE:
			return "greataxe"
		ITEM_TYPE.DAGGER:
			return "dagger"
		ITEM_TYPE.GREATHAMMER:
			return "greathammer"
		ITEM_TYPE.HAMMER:
			return "hammer"
		ITEM_TYPE.KATANA:
			return "katana"
		ITEM_TYPE.SPEAR:
			return "spear"
		ITEM_TYPE.BOW:
			return "bow"
		ITEM_TYPE.TORCH:
			return "torch"
		ITEM_TYPE.SHIELD:
			return "shield"
		ITEM_TYPE.FIST:
			return "fist"
	return ""

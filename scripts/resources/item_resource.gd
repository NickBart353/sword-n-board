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

var stack_size: int = 1

enum ITEM_CATEGORY {WEAPON, ARMOR, CONSUMABLE, MATERIAL}
enum ITEM_SUB_CATEGORY {MELEE_WEAPON, RANGED_WEAPON, MAGIC_WEAPON, POTION, SHARD}
enum ITEM_TYPE {SWORD, BOOK, BOW, POTION, MANA_POTION, TORCH, SHIELD}

func get_item_category_value(value: ITEM_CATEGORY) -> String:
	match value:
		ITEM_CATEGORY.WEAPON:
			return "Weapon"
		ITEM_CATEGORY.ARMOR:
			return "Armor"
		ITEM_CATEGORY.CONSUMABLE:
			return "Consumable"
		ITEM_CATEGORY.MATERIAL:
			return "Material"
	return ""

func get_item_sub_category_value(value: ITEM_SUB_CATEGORY) -> String:
	match value:
		ITEM_SUB_CATEGORY.MELEE_WEAPON:
			return "Melee Weapon"
		ITEM_SUB_CATEGORY.RANGED_WEAPON:
			return "Ranged Weapon"
		ITEM_SUB_CATEGORY.MAGIC_WEAPON:
			return "Magic Weapon"
		ITEM_SUB_CATEGORY.POTION:
			return "Potion"
		ITEM_SUB_CATEGORY.SHARD:
			return "Shard"
	return ""

func get_item_type_value(value: ITEM_TYPE) -> String:
	match value:
		ITEM_TYPE.SWORD:
			return "Sword"
		ITEM_TYPE.BOOK:
			return "Book"
		ITEM_TYPE.BOW:
			return "Bow"
		ITEM_TYPE.POTION:
			return "Potion"
		ITEM_TYPE.TORCH:
			return "Torch"
		ITEM_TYPE.SHIELD:
			return "Shield"
	return ""

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
@export var item_type: ITEM_TYPE

var stack_size: int = 1

enum ITEM_CATEGORY {MELEE_WEAPON, RANGED_WEAPON, MAGIC_WEAPON, OFF_HAND, CONSUMABLE}
enum ITEM_TYPE {SWORD, BOOK, BOW, POTION, TORCH, SHIELD}

func get_item_category_value(value: ITEM_CATEGORY) -> String:
	match value:
		ITEM_CATEGORY.MELEE_WEAPON:
			return "Melee Weapon"
		ITEM_CATEGORY.RANGED_WEAPON:
			return "Ranged Weapon"
		ITEM_CATEGORY.MAGIC_WEAPON:
			return "Magic Weapon"
		ITEM_CATEGORY.OFF_HAND:
			return "Offhand"
		ITEM_CATEGORY.CONSUMABLE:
			return "Consumable"
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

class_name ItemData
extends Resource

@export var item_name: String
@export var item_id: String
@export_multiline var tooltip: String
@export var stackable: bool = false
@export var sprite: Texture2D
@export var drop_chance: float
@export var mesh: Mesh
@export var item_category: ITEM_CATEGORY
@export var item_type: ITEM_TYPE

enum ITEM_CATEGORY {MELEE_WEAPON, RANGED_WEAPON, MAGIC_WEAPON, OFF_HAND, CONSUMABLE}
enum ITEM_TYPE {t, e, s}

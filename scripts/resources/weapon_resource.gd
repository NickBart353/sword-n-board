@tool
extends ItemData
class_name WeaponData

@export var single_base_damage: float = 0.0
@export var single_base_incrementor: float = 0.0
@export var hybrid_normal_base_damge: float = 0.0
@export var hybrid_normal_base_incrementor: float = 0.0
@export var hybrid_elemental_base_damage: float = 0.0
@export var hybrid_elemental_base_incrementor: float = 0.0

@export_group("Damage")
@export var normal_damage: float = 5.0
@export var magic_damage: float = 0.0
@export var fire_damage: float = 0.0
@export var lightning_damage: float = 0.0
@export var cold_damage: float = 0.0
@export var nature_damage: float = 0.0
@export var chaos_damage: float = 0.0

@export var critical_strike_chance: float = 0.05

@export_range(1,4) var combo_size: int = 3

@export var two_handed: bool = false:
	set(value):
		two_handed = value
		notify_property_list_changed()

@export_range(1, 5) var dualwield_combo_size: int = 3

@export var knockbackStrength_vertical: int = 0
@export var knockbackStrength_horizontal: int = 0

@export var upgrade_level: int = 0
@export var upgrade_type: UPGRADE_TYPE = UPGRADE_TYPE.NORMAL

var damage_resource: DamageResource

enum UPGRADE_TYPE {NORMAL, MAGIC, FIRE, LIGHTNING, COLD, NATURE, CHAOS}

static var prefix_dict: Dictionary = {
		UPGRADE_TYPE.FIRE: "Flaming",
		UPGRADE_TYPE.COLD: "Frozen",
		UPGRADE_TYPE.LIGHTNING: "Lightning",
		UPGRADE_TYPE.NATURE: "Nature",
		UPGRADE_TYPE.CHAOS: "Chaos",
}

static func get_upgrade_type_name_prefix(type: UPGRADE_TYPE) -> String:
	if prefix_dict.has(type):
		return prefix_dict[type]
	return ""

static func get_upgrade_type_sprite(modified_item_name: String) -> Texture2D:
	var path: String = "res://my_assets/sprites/"
	var formatted_path: String = "{0}{1}.png".format([path, modified_item_name])
	prints("path", formatted_path)
	if ResourceLoader.exists(formatted_path):
		return load(formatted_path)
	return null

func _validate_property(property: Dictionary):
	if property.name in ["dualwield_combo_size"]:
		if two_handed:
			property.usage &= ~PROPERTY_USAGE_EDITOR

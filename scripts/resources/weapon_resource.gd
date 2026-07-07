@tool
extends ItemData
class_name WeaponData

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
@export var upgrade_type: UPGRADE_TYPE

enum UPGRADE_TYPE {NORMAL, MAGIC, FIRE, LIGHTNING, COLD, NATURE, CHAOS}

func _validate_property(property: Dictionary):
	if property.name in ["dualwield_combo_size"]:
		if two_handed:
			property.usage &= ~PROPERTY_USAGE_EDITOR

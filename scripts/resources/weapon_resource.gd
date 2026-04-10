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

@export var two_handed: bool = false
@export var knockbackStrength_vertical: int = 0
@export var knockbackStrength_horizontal: int = 0

var upgrade_level: int = 0
var upgrade_type: UPGRADE_TYPE

enum UPGRADE_TYPE {NORMAL, MAGIC, FIRE, LIGHTNING, COLD, NATURE, CHAOS}

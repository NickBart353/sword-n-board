@tool
class_name ConsumableData extends ItemData

@export_group("Consumable")
@export var use_basic_attribute: bool = true:
	set(value):
		use_basic_attribute = value
		notify_property_list_changed()

@export var player_property: String
@export var property_type: PROPERTY_TYPE
@export var amount: float = 1.0

@export var temporary: bool = false:
	set(value):
		temporary = value
		notify_property_list_changed()
@export var duration_seconds: float = 30

@export var consumable_type: CONSUME_TYPE
@export var model: PackedScene
@export var model_scale: float = 1.0
@export var vfx: PackedScene

@export var use_light: bool = false:
	set(value):
		use_light = value
		notify_property_list_changed()

@export_range(0.0, 5.0) var light_range: float = 0.4
@export_range(0.0, 5.0) var light_energy: float = 0.175
@export var light_color: Color

enum PROPERTY_TYPE {INCREASE, DECREASE, INCREASE_MAX, DECREASE_MAX}
enum CONSUME_TYPE {EAT, DRINK}

func _validate_property(property: Dictionary):
	if property.name in ["player_property", "property_type", "amount"]:
		if not use_basic_attribute:
			property.usage &= ~PROPERTY_USAGE_EDITOR
	
	if property.name in ["light_range", "light_energy", "light_color"]:
		if not use_light:
			property.usage &= ~PROPERTY_USAGE_EDITOR
	
	if property.name in ["duration_seconds"]:
		if not temporary:
			property.usage &= ~PROPERTY_USAGE_EDITOR

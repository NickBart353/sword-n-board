class_name Potion extends Consumable

@export var property: String
@export var property_type: PROPERTY_TYPE
@export var amount: float

enum PROPERTY_TYPE {INCREASE, DECREASE, INCREASE_MAX, DECREASE_MAX}

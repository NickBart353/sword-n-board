extends InventoryItemText

@onready var item_name: Label = $WeaponStats/ItemName
@onready var flavor_text: Label = $WeaponStats/FlavorText
@onready var type: Label = $WeaponStats/ItemType/Type
@onready var normal_value: Label = $WeaponStats/Normal/NormalValue
@onready var magic_value: Label = $WeaponStats/Magic/MagicValue
@onready var fire_value: Label = $WeaponStats/Fire/FireValue
@onready var lightning_value: Label = $WeaponStats/Lightning/LightningValue
@onready var cold_value: Label = $WeaponStats/Cold/ColdValue
@onready var nature_value: Label = $WeaponStats/Nature/NatureValue
@onready var chaos_value: Label = $WeaponStats/Chaos/ChaosValue

func _ready() -> void:
	hide()

func set_text(item: Item):
	item_name.text = item.data.item_name
	flavor_text.text = item.data.tooltip
	type.text = item.data.get_item_type_value(item.data.item_type)
	normal_value.text = "{0}".format([item.data.normal_damage])
	magic_value.text = "{0}".format([item.data.magic_damage])
	fire_value.text = "{0}".format([item.data.fire_damage])
	lightning_value.text = "{0}".format([item.data.lightning_damage])
	cold_value.text = "{0}".format([item.data.cold_damage])
	nature_value.text = "{0}".format([item.data.nature_damage])
	chaos_value.text = "{0}".format([item.data.chaos_damage])

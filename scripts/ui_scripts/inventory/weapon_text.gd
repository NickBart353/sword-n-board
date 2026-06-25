extends InventoryItemText

@export var item_name: Label
@export var flavor_text: Label
@export var type: Label
@export var normal_value: Label
@export var magic_value: Label
@export var fire_value: Label
@export var lightning_value: Label
@export var cold_value: Label
@export var nature_value: Label
@export var chaos_value: Label

func _ready() -> void:
	hide()

func set_text(item: Item):
	item_name.text = item.data.item_name
	flavor_text.text = item.data.tooltip
	type.text = ItemData.get_item_type_value(item.data.item_type)
	normal_value.text = "{0}".format([item.data.normal_damage])
	magic_value.text = "{0}".format([item.data.magic_damage])
	fire_value.text = "{0}".format([item.data.fire_damage])
	lightning_value.text = "{0}".format([item.data.lightning_damage])
	cold_value.text = "{0}".format([item.data.cold_damage])
	nature_value.text = "{0}".format([item.data.nature_damage])
	chaos_value.text = "{0}".format([item.data.chaos_damage])

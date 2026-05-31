extends InventoryItemText

@onready var label: Label = $WeaponStats/Label
@onready var info_text_label: Label = $WeaponStats/InfoTextLabel
@onready var type: Label = $WeaponStats/ItemType/Type

func set_text(item: Item):
	label.text = item.data.item_name
	info_text_label.text = item.data.explanation_text
	type.text = ItemData.get_item_type_value(item.data.item_type)

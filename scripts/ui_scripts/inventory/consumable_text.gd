extends InventoryItemText

@export var label: Label
@export var info_text_label: Label
@export var type: Label

func set_text(item: Item):
	label.text = item.data.get_combined_name()
	info_text_label.text = item.data.tooltip
	type.text = ItemData.get_item_type_value(item.data.item_type)

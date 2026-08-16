extends InventoryItemText

@export var name_label: Label
@export var info_text_label: Label
@export var type_label: Label

func set_text(item: Item):
	name_label.text = item.data.get_combined_name()
	info_text_label.text = item.data.tooltip
	type_label.text = ItemData.get_item_type_value(item.data.item_type)

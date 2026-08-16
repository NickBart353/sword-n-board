class_name InterfaceItemHorizontal extends PanelContainer

@onready var label: Label = $HBoxContainer/VBoxContainer/Label
@onready var label_2: Label = $HBoxContainer/VBoxContainer/Label2
@onready var label_3: Label = $HBoxContainer/VBoxContainer/Label3
@onready var texture_rect: TextureRect = $HBoxContainer/TextureRect

func set_data(itemdata: ItemData) -> void:
	label.text = itemdata.get_combined_name()
	label_2.text = itemdata.explanation_text if itemdata.explanation_text != "" else itemdata.tooltip
	label_3.text = str(itemdata.stack_size)
	texture_rect.texture = itemdata.sprite

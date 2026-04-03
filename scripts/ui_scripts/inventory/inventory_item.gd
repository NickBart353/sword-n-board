class_name InventoryItem extends Button

signal item_hovered
signal item_pressed

var item: Item

func _on_mouse_entered() -> void:
	item_hovered.emit(item)

func _on_pressed() -> void:
	item_pressed.emit(item)

func set_data(new_item: Item):
	item = new_item
	text = item.data.item_name
	icon = item.data.sprite

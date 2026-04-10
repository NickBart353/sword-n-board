class_name EquippedItem extends UIItem

func _gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				item_pressed.emit(self, item, "LEFT", slot)
			MOUSE_BUTTON_RIGHT:
				item_pressed.emit(self, item, "RIGHT", slot)

func _on_mouse_entered() -> void:
	item_hovered.emit(item)

func set_data(new_item: Item, new_slot: String = "") -> void:
	item = new_item
	text = item.data.item_name
	icon = item.data.sprite
	slot = new_slot

func set_slot(new_slot: String) -> void:
	slot = new_slot

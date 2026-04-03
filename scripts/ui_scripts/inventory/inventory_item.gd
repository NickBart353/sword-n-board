class_name InventoryItem extends Button

signal item_hovered
signal item_pressed

@onready var consumable_marker: ColorRect = $ConsumableMarker

var item: Item
var slot: String = ""

func _ready() -> void:
	consumable_marker.hide()

func _gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				item_pressed.emit(self, item, "LEFT", slot)
			MOUSE_BUTTON_RIGHT:
				item_pressed.emit(self, item, "RIGHT", slot)

func _on_mouse_entered() -> void:
	item_hovered.emit(item)

#func _on_pressed() -> void:
	#item_pressed.emit(item)

func set_data(new_item: Item) -> void:
	item = new_item
	text = item.data.item_name
	icon = item.data.sprite

func set_slot(new_slot: String) -> void:
	slot = new_slot

func mark_consumable():
	consumable_marker.show()

func unmark_consumable():
	consumable_marker.hide()

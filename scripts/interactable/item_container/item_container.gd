class_name ItemContainer
extends Interactable

var items: Array = []
var open = false
var parent: String = ""

signal items_empty

func _ready() -> void:
	super()
	EventBus.update_items.connect(update_items)

func interact():
	super()
	if open:
		open = false
		EventBus.close_container.emit(self)
	else:
		open = true
		EventBus.open_container.emit(self)

func hover():
	super()
	hovered = true

func un_hover():
	super()
	if hovered:
		EventBus.close_container.emit(self)
		open = false
		hovered = false

func update_items(new_items, sack_name):
	if sack_name == parent:
		items = new_items
		if items.is_empty():
			EventBus.close_container.emit(self)
			items_empty.emit()

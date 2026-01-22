class_name ItemContainer
extends Interactable

var items: Array = []
var open = false
var parent: String

signal open_container
signal close_container
signal items_empty

func _ready() -> void:
	super()

func interact():
	super()
	if open:
		open = false
		close_container.emit()
	else:
		open = true
		open_container.emit(items, parent)

func hover():
	super()
	hovered = true

func un_hover():
	super()
	if hovered:
		close_container.emit()
		open = false
		hovered = false

func update_items(new_items):
	items = new_items
	if items.is_empty():
		close_container.emit()
		items_empty.emit()

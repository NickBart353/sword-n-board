class_name ItemSack
extends RigidBody3D

var items: Array = []
var open = false
var hovered = false
signal open_sack
signal close_sack

func _ready() -> void:
	$Interactable._interact.connect(interact)
	$Interactable._hover.connect(hover)
	$Interactable._un_hover.connect(un_hover)

func hover():
	hovered = true

func un_hover():
	if hovered:
		close_sack.emit()
		open = false
		hovered = false

func interact():
	if open:
		open = false
		close_sack.emit()
	else:
		open = true
		open_sack.emit(items, name)

func update_items(new_items):
	items = new_items
	if items.is_empty():
		close_sack.emit()
		queue_free()

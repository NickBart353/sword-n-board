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
	#if not $Entrance/BlackSquare/Outline.is_visible():
		#$Entrance/BlackSquare/Outline.set_visible(true)
	hovered = true
	if not $Sprite3D.is_visible():
		$Sprite3D.set_visible(true)

func un_hover():
	#if $Entrance/BlackSquare/Outline.is_visible():
		#$Entrance/BlackSquare/Outline.set_visible(false)
	if hovered:
		$Sprite3D.set_visible(false)
		close_sack.emit()
		open = false
		hovered = false
	#if items.is_empty():
		#close_sack.emit()
		#queue_free()

func interact():
	if open:
		open = false
		close_sack.emit()
	else:
		open = true
		open_sack.emit(items, name)

class_name ItemSack
extends RigidBody3D

var items: Array = []
signal open_inventory
signal close_inventory

func _ready() -> void:
	for item in items:
		$ItemList.add_item(item.data.item_name)
	$Interactable._interact.connect(interact)
	$Interactable._hover.connect(hover)
	$Interactable._un_hover.connect(un_hover)

func hover():
	#if not $Entrance/BlackSquare/Outline.is_visible():
		#$Entrance/BlackSquare/Outline.set_visible(true)
	if not $Sprite3D.is_visible():
		$Sprite3D.set_visible(true)

func un_hover():
	#if $Entrance/BlackSquare/Outline.is_visible():
		#$Entrance/BlackSquare/Outline.set_visible(false)
	$Sprite3D.set_visible(false)
	$ItemList.set_visible(false)
	close_inventory.emit()

func interact():
	$ItemList.set_visible(!$ItemList.is_visible())
	open_inventory.emit()

func close_windows():
	$ItemList.set_visible(false)

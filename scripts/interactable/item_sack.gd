class_name ItemSack
extends RigidBody3D

signal remove_me

func _ready() -> void:
	$ItemContainer.items_empty.connect(_remove_me)
	$ItemContainer.parent = name

func _remove_me():
	remove_me.emit(self)
	

class_name ItemSack
extends RigidBody3D

func _ready() -> void:
	$ItemContainer.items_empty.connect(_remove_me)
	$ItemContainer.parent = name

func _remove_me():
	EventBus.remove_me.emit(self)
	

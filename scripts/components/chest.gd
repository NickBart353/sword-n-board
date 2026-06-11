class_name Chest extends StaticBody3D

@export var item_container: ItemContainer
@export var chest_id: String

var is_dirty: bool = false

func _ready() -> void:
	if not item_container.updated.is_connected(_dirty):
		item_container.updated.connect(_dirty)

func _dirty() -> void:
	is_dirty = true

func clean() -> void:
	is_dirty = false

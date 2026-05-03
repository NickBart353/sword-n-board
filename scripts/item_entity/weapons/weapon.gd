@abstract class_name Weapon extends ItemEntity

@export var hand_component: Node3D

var marker_positions: Dictionary

func get_markers() -> Dictionary:
	return hand_component.get_markers()

func update_markers(side: String) -> void:
	_set_marker_values()
	hand_component.update_markers(side, marker_positions)

@abstract func _set_marker_values()

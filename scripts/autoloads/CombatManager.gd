extends Node

signal left_combat

var combat_units: int = 0

func _ready() -> void:
	combat_units = 0

func add_unit() -> void:
	combat_units += 1

func remove_unit() -> void:
	combat_units -= 1
	if combat_units < 0:
		combat_units = 0
	if combat_units == 0:
		print("emitting")
		left_combat.emit()

func is_in_combat() -> bool:
	return combat_units > 0

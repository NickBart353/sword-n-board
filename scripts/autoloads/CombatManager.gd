extends Node

signal left_combat

var combat_units: int = 0
var combat_unit_ids: Array[String]

func _ready() -> void:
	combat_unit_ids = []

func add_unit(new_id: String) -> void:
	combat_unit_ids.append(new_id)

func remove_unit(remove_id: String) -> void:
	if remove_id in combat_unit_ids:
		combat_unit_ids.erase(remove_id)
	else:
		push_warning("ID wasnt in combat: ", remove_id)
	if not is_in_combat():
		left_combat.emit()

func is_in_combat() -> bool:
	return combat_unit_ids.size() > 0

func clear_combat() -> void:
	combat_unit_ids.clear()

#func _ready() -> void:
	#combat_units = 0

#func add_unit() -> void:
	#combat_units += 1

#func remove_unit() -> void:
	#combat_units -= 1
	#if combat_units < 0:
		#combat_units = 0
	#if combat_units == 0:
		#left_combat.emit()

#func is_in_combat() -> bool:
	#return combat_units > 0

#func clear_combat() -> void:
	#combat_units = 0

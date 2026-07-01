extends Node

var item_sack: PackedScene = preload("uid://bhogse4uknt02")
var toxic_ground: PackedScene = preload("uid://4fwojmdcec7c")

var min_amount_item_sack: int = 10
var item_sack_container: Node3D
var available_sacks: Array[ItemSack] = []

var min_amount_toxic_ground: int = 200
var toxic_ground_container: Node3D
var available_toxic_grounds: Array[DOT] = []

func _ready() -> void:
	item_sack_container = Node3D.new()
	add_child(item_sack_container)
	for counter in range(min_amount_item_sack):
		var item_sack_instance: ItemSack = item_sack.instantiate()
		item_sack_container.add_child(item_sack_instance)
		_deactivate_object(item_sack_instance)
	
	toxic_ground_container = Node3D.new()
	add_child(toxic_ground_container)
	for counter in range(min_amount_toxic_ground):
		var toxic_ground_instance: DOT = toxic_ground.instantiate()
		toxic_ground_container.add_child(toxic_ground_instance)
		_deactivate_object(toxic_ground_instance)

func reset_object(object: Variant) -> void:
	_deactivate_object(object)

func _deactivate_object(object: Variant) -> void:
	object.set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)
	object.global_position = Vector3(-10000, -10000, -10000)
	
	if object is ItemSack:
		available_sacks.append(object)
	elif object is DOT:
		available_toxic_grounds.append(object)

func _create_new_sack() -> ItemSack:
	var item_sack_instance: ItemSack = item_sack.instantiate()
	item_sack_container.add_child(item_sack_instance)
	return item_sack_instance

func get_free_item_sack() -> ItemSack:
	var sack: ItemSack
	if available_sacks.is_empty():
		sack = _create_new_sack()
	else:
		sack = available_sacks.pop_back()
	sack.set_deferred("process_mode", Node.PROCESS_MODE_INHERIT)
	sack.activate_timer()
	return sack

func _create_new_toxic_ground() -> DOT:
	var toxic_ground_instance: DOT = toxic_ground.instantiate()
	toxic_ground_container.add_child(toxic_ground_instance)
	return toxic_ground_instance

func get_free_toxic_ground() -> DOT:
	var toxic_ground_instance: DOT
	if available_toxic_grounds.is_empty():
		toxic_ground_instance = _create_new_toxic_ground()
	else:
		toxic_ground_instance = available_toxic_grounds.pop_back()
	toxic_ground_instance.set_deferred("process_mode", Node.PROCESS_MODE_INHERIT)
	return toxic_ground_instance

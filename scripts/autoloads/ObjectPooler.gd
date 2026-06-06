extends Node

var item_sack: PackedScene = preload("uid://bhogse4uknt02")
var min_amount_item_sack: int = 10
var item_sack_container: Node3D
var available_sacks: Array[ItemSack] = []

func _ready() -> void:
	item_sack_container = Node3D.new()
	add_child(item_sack_container)
	for counter in range(min_amount_item_sack):
		var item_sack_instance: ItemSack = item_sack.instantiate()
		item_sack_container.add_child(item_sack_instance)
		_deactivate_sack(item_sack_instance)

func get_free_item_sack() -> ItemSack:
	var sack: ItemSack
	if available_sacks.is_empty():
		sack = _create_new_sack()
	else:
		sack = available_sacks.pop_back()
	sack.set_deferred("process_mode", Node.PROCESS_MODE_INHERIT)
	sack.activate_timer()
	return sack

func reset_item_sack(sack) -> void:
	_deactivate_sack(sack)

func _create_new_sack() -> ItemSack:
	var item_sack_instance: ItemSack = item_sack.instantiate()
	item_sack_container.add_child(item_sack_instance)
	return item_sack_instance

func _deactivate_sack(sack: ItemSack) -> void:
	sack.set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)
	sack.global_position = Vector3(-10000, -10000, -10000)
	available_sacks.append(sack)

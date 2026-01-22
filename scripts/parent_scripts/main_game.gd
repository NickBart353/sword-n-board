class_name Main
extends Node3D

const ITEM_SACK: PackedScene = preload("res://scenes/component_scenes/interactable/item_sack.tscn")
@onready var main_ui = $CanvasLayer/MainUI

func _ready() -> void:
	$Player.open_inventory.connect(open_inventory)
	$ItemSack.get_node("ItemContainer").close_container.connect(_close_container)
	$ItemSack.get_node("ItemContainer").open_container.connect(_open_container)
	$ItemSack.remove_me.connect(remove_object)
	main_ui.update_items.connect(update_items)
	for enemy in $Mobs.get_children():
		enemy.died.connect(_enemy_died)
	for chest in $Building.get_node("Chests").get_children():
		chest.get_node("ItemContainer").close_container.connect(_close_container)
		chest.get_node("ItemContainer").open_container.connect(_open_container)

func _enemy_died(enemy: Node3D):
	_generate_loot_on_enemy_death(enemy.global_position, enemy.level)

func _generate_loot_on_enemy_death(loot_position: Vector3, enemy_level):
	var items_to_generate: Array = ItemManager.generate_loot(enemy_level)
	if not items_to_generate: return
	var item_sack_instance = ITEM_SACK.instantiate()
	item_sack_instance.get_node("ItemContainer").items = items_to_generate
	item_sack_instance.get_node("ItemContainer").close_container.connect(_close_container)
	item_sack_instance.get_node("ItemContainer").open_container.connect(_open_container)
	item_sack_instance.remove_me.connect(remove_object)
	$Loot.add_child(item_sack_instance, true)
	item_sack_instance.global_position = loot_position

func open_inventory(items):
	var show_ui = not main_ui.get_inventory()
	_change_ui_state(show_ui)
	main_ui.fill_inventory(items)
	main_ui.open_inventory()

func _open_container(items, sack_name):
	_change_ui_state(true)
	main_ui.fill_loot(items)
	main_ui.open_sack(sack_name)

func _close_container():
	_change_ui_state(false)
	main_ui.close_sack()

func _change_ui_state(show_ui: bool):
	$CanvasLayer.set_visible(show_ui)
	if show_ui:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func update_items(player_items, loot_items, sack_name):
	$Player.items = player_items
	if $Loot.get_node_or_null("{0}".format([sack_name])):
		$Loot.get_node_or_null("{0}".format([sack_name])).get_node("ItemContainer").update_items(loot_items)

func remove_object(object):
	object.queue_free()

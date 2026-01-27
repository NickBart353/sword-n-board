class_name Main
extends Node3D

const ITEM_SACK: PackedScene = preload("res://scenes/component_scenes/interactable/item_sack.tscn")
@onready var main_ui = $CanvasLayer/MainUI

func _ready() -> void:
	EventBus.close_container.connect(_close_container)
	EventBus.open_container.connect(_open_container)
	EventBus.remove_me.connect(remove_object)
	
	VfxManager.create_vfx.connect(_create_vfx)
	
	$Player.open_inventory.connect(open_inventory)
	main_ui.update_items.connect(update_items)
	
	for enemy in $Mobs.get_children():
		enemy.died.connect(_enemy_died)

func _enemy_died(enemy: Node3D):
	_generate_loot_on_enemy_death(enemy.global_position, enemy.level)

func _generate_loot_on_enemy_death(loot_position: Vector3, enemy_level):
	var items_to_generate: Array = ItemManager.generate_loot(enemy_level)
	if not items_to_generate: return
	var item_sack_instance = ITEM_SACK.instantiate()
	item_sack_instance.get_node("ItemContainer").items = items_to_generate
	$Loot.add_child(item_sack_instance, true)
	item_sack_instance.global_position = loot_position

func open_inventory(items):
	var show_ui = not main_ui.get_inventory()
	_change_ui_state(show_ui)
	main_ui.fill_inventory(items)
	main_ui.open_inventory()

func _open_container(container):
	_change_ui_state(true)
	main_ui.fill_loot(container.items)
	main_ui.open_sack(container.parent)

func _close_container(_container):
	_change_ui_state(false)
	main_ui.close_sack(_container)

func _change_ui_state(show_ui: bool):
	$CanvasLayer.set_visible(show_ui)
	if show_ui:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func update_items(player_items, loot_items, sack_name):
	EventBus.update_items.emit(loot_items, sack_name)
	$Player.items = player_items

func remove_object(object):
	object.queue_free()

func _create_vfx(vfx_position: Vector3, scene: PackedScene):
	var instance = scene.instantiate()
	$Vfx.add_child(instance)
	instance.global_position = vfx_position

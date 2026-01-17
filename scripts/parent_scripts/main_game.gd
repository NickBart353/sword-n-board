class_name Main
extends Node3D

const ITEM_SACK: PackedScene = preload("res://scenes/component_scenes/interactable/item_sack.tscn")
@onready var main_ui = $CanvasLayer/MainUI

func _ready() -> void:
	$ProtoController.open_inventory.connect(open_inventory)
	#$ItemSack.close_sack.connect(_close_sack)
	#$ItemSack.open_sack.connect(_open_sack)
	main_ui.update_items.connect(update_items)
	#for enemy in $Mobs.get_children():
		#enemy.died.connect(_enemy_died)

func _enemy_died(enemy: Node3D):
	_generate_loot_on_enemy_death(enemy.global_position, enemy.level)

func _generate_loot_on_enemy_death(loot_position: Vector3, enemy_level):
	var items_to_generate: Array = ItemManager.generate_loot(enemy_level)
	if not items_to_generate: return
	var item_sack_instance = ITEM_SACK.instantiate()
	item_sack_instance.transform.origin = loot_position
	item_sack_instance.items = items_to_generate
	item_sack_instance.close_sack.connect(_close_sack)
	item_sack_instance.open_sack.connect(_open_sack)
	$Loot.add_child(item_sack_instance, true)

func open_inventory(items):
	var show_ui = not main_ui.get_inventory()
	_change_ui_state(show_ui)
	main_ui.fill_inventory(items)
	main_ui.open_inventory()

func _open_sack(items, sack_name):
	_change_ui_state(true)
	main_ui.fill_loot(items)
	main_ui.open_sack(sack_name)

func _close_sack():
	_change_ui_state(false)
	main_ui.close_sack()

func _change_ui_state(show_ui: bool):
	$CanvasLayer.set_visible(show_ui)
	if show_ui:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func update_items(player_items, loot_items, sack_name):
	$ProtoController.items = player_items
	if $Loot.get_node_or_null("{0}".format([sack_name])):
		$Loot.get_node_or_null("{0}".format([sack_name])).update_items(loot_items)
	

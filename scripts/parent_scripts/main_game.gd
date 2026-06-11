class_name Main
extends Node3D

const ITEM_SACK: PackedScene = preload("res://scenes/component_scenes/interactable/item_sack.tscn")
const player_scene: PackedScene = preload("res://scenes/component_scenes/characters/player_new.tscn")

@onready var main_ui = $CanvasLayer/MainUI
var player: CharacterBody3D

func _ready() -> void:
	_spawn_player()
	
	EventBus.close_container.connect(_close_container)
	EventBus.open_container.connect(_open_container)
	EventBus.remove_me.connect(remove_object)
	EventBus.spawn_loot.connect(_enemy_died)
	
	VfxManager.create_vfx.connect(_create_vfx)
	
	_spawn_mobs()
	
	main_ui.update_items.connect(update_items)
	GameStateSaver.start()

func _enemy_died(enemy: Node3D):
	_generate_loot_on_enemy_death(enemy.global_position, enemy.level)

func _generate_loot_on_enemy_death(loot_position: Vector3, enemy_level):
	var items_to_generate: Array = ItemManager.generate_loot(enemy_level)
	if not items_to_generate: return
	
	var item_sack_instance = ObjectPooler.get_free_item_sack()
	item_sack_instance.get_node("ItemContainer").items = items_to_generate
	#$Loot.add_child(item_sack_instance, true)
	item_sack_instance.global_position = Vector3(loot_position.x, loot_position.y + 1.0, loot_position.z)
	#item_sack_instance._remove_me()
	
	var vfx_instance = VfxManager.create_vfx_from_enum(VfxManager.VFX.LOOT_PUFF, loot_position, true).instantiate()
	add_child(vfx_instance)
	vfx_instance.global_position = loot_position
	vfx_instance.play()

func open_inventory(inventory: Array, head: Item, body: Item, boots: Item, main_hand: Item, off_hand: Item, consumable: Item):
	var show_ui = not main_ui.get_ui()
	_change_ui_state(show_ui)
	
	main_ui.fill_character_items(inventory, head, body, boots, main_hand, off_hand, consumable)
	main_ui.open_inventory()

func _open_container(container: Node):
	_change_ui_state(true)
	main_ui.fill_player_items(player.items, player.head_item, player.body_item, player.boots_item, player.main_hand_item, player.off_hand_item, player.consumable_item)
	main_ui.fill_loot(container.items)
	main_ui.open_sack(container)

func _close_container(_container):
	_change_ui_state(false)
	main_ui.close_sack(_container)

func _change_ui_state(show_ui: bool):
	$CanvasLayer.set_visible(show_ui)
	if show_ui:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func update_items(player_items, loot_items, sack: Node, head_item: Item, body_item: Item, boots_item: Item, main_hand_item: Item, off_hand_item: Item, consumable_item: Item):
	var parent_name: String = sack.parent.name if sack else ""
	EventBus.update_items.emit(loot_items, parent_name)
	player.update_items(player_items, head_item, body_item, boots_item, main_hand_item, off_hand_item, consumable_item)

func remove_object(object):
	object.queue_free()

func _spawn_projectile(projectile: Node, spawn_position: Vector3, shooting_direction: Vector3, proj_transform: Transform3D, direction_flag: bool = false):
	$Attacks.add_child(projectile, true)
	projectile.fire(spawn_position, shooting_direction, proj_transform, direction_flag)
	projectile.exploded.connect(remove_object)

func _create_vfx(vfx_position: Vector3, scene: PackedScene, new_global_rotation = null):
	var instance = scene.instantiate()
	$Vfx.add_child(instance, true)
	instance.global_position = vfx_position
	if new_global_rotation:
		instance.rotation = new_global_rotation
	instance.play()

func _spawn_mobs():
	for mob_spawn_group in $MobSpawns.get_children():
		if mob_spawn_group is MobTypePicker:
			for mob_spawn in mob_spawn_group.get_children():
				if mob_spawn is MobSpawn:
					var mob_instance = MobManager.spawn_mob_from_enum(mob_spawn_group.mob).instantiate()
					if mob_instance:
						mob_spawn.add_child(mob_instance)
						if not mob_instance.died.is_connected(mob_spawn.mob_died):
							mob_instance.died.connect(mob_spawn.mob_died)

func _spawn_player():
	player = player_scene.instantiate()
	var basic_player_resource: BasicPlayerData = DataManager.load_basic_player_data()
	add_child(player)
	if basic_player_resource:
		print("loaded res: ", basic_player_resource.position)
		player.HEALTH = basic_player_resource.health
		player.STAMINA = basic_player_resource.stamina
		player.MANA = basic_player_resource.mana
		player.global_position = basic_player_resource.position
		player.global_rotation = basic_player_resource.rotation
		#player.spirit = basic_player_resource.spirit
	else:
		player.global_position = $PlayerSpawn.global_position
	player.open_inventory.connect(open_inventory)
	player.spawn_projectile.connect(_spawn_projectile)

class_name Main
extends Node3D

const ITEM_SACK: PackedScene = preload("res://scenes/component_scenes/interactable/item_sack.tscn")
const player_scene: PackedScene = preload("res://scenes/component_scenes/characters/player_new.tscn")

@export var game_menus: CanvasLayer
@export var mob_spawns: Node3D
@export var player_spawn: Marker3D
@export var world_loot: Node3D

#@onready var main_ui = $CanvasLayer/MainUI
var player: Player

var mobspawn_data: Dictionary

var processing_queue: Array[MobSpawn] = []
var remove_queue: Array[MobSpawn] = []
var _enemies: Dictionary[String, MobSpawn] = {}

var spawn_queue_counter: int = 0
var spawn_queue_counter_limit: int = 0

func _ready() -> void:
	#DataManager.connect_db()
	#_spawn_mobs()
	_assign_mobspawns_to_dict()
	_spawn_world_loot()
	_load_chests()
	_spawn_player()
	
	WorldChunker.reload_enemies.connect(_reload_enemies)
	WorldChunker.set_player(player)
	WorldChunker.chunk(_enemies.values())
	
	#EventBus.close_container.connect(_close_container)
	#EventBus.open_container.connect(_open_container)
	EventBus.remove_me.connect(remove_object)
	EventBus.spawn_loot.connect(_enemy_died)
	
	VfxManager.create_vfx.connect(_create_vfx)
	
	game_menus.continue_game.connect(_continue_game)
	
	#main_ui.update_items.connect(update_items)
	GameStateSaver.start()

func _process(_delta: float) -> void:
	if not processing_queue.is_empty():
		var _mobspawn: MobSpawn = processing_queue.pop_back()
		
		_mobspawn = _enemies[_mobspawn.spawn_id]
		var mob_spawn_group: MobTypePicker = _mobspawn.get_parent()
		
		if mobspawn_data.get(_mobspawn.spawn_id) != null:
			if mobspawn_data.get(_mobspawn.spawn_id) == true:
				return
		var mob_instance = MobManager.spawn_mob_from_enum(mob_spawn_group.mob).instantiate()
		if mob_instance:
			_mobspawn.add_child(mob_instance)
			if mob_spawn_group.mob != MobManager.MOBS.WASP:
				mob_instance.global_position = Vector3(mob_instance.global_position.x, mob_instance.global_position.y + 5, mob_instance.global_position.z)
			if not mob_instance.died.is_connected(_mobspawn.mob_died):
				mob_instance.died.connect(_mobspawn.mob_died)
	elif not remove_queue.is_empty():
		var _mobspawn: MobSpawn = remove_queue.pop_back()
		
		_mobspawn = _enemies[_mobspawn.spawn_id]
		
		if mobspawn_data.get(_mobspawn.spawn_id) != null:
			if mobspawn_data.get(_mobspawn.spawn_id) == true:
				return
		for mob in _mobspawn.get_children():
			mob.queue_free()
	else:
		set_process(false)

func _enemy_died(enemy: Node3D):
	_generate_loot_on_enemy_death(enemy.global_position, enemy)

func _generate_loot_on_enemy_death(loot_position: Vector3, enemy: Enemy):
	var items_to_generate: Array = ItemManager.generate_loot(enemy.level)
	if not items_to_generate: return
	
	var item_sack_instance = ObjectPooler.get_free_item_sack()
	item_sack_instance.get_node("ItemContainer").items = items_to_generate
	item_sack_instance.enemy_name = enemy.display_name
	#$Loot.add_child(item_sack_instance, true)
	item_sack_instance.global_position = Vector3(loot_position.x, loot_position.y + 1.0, loot_position.z)
	#item_sack_instance._remove_me()
	
	var vfx_instance = VfxManager.create_vfx_from_enum(VfxManager.VFX.LOOT_PUFF, loot_position, true).instantiate()
	add_child(vfx_instance)
	vfx_instance.global_position = loot_position
	vfx_instance.play()

func _reload_enemies(enemies_to_load: Array[MobSpawn], enemies_to_unload: Array[MobSpawn]) -> void:
	mobspawn_data = GameStateSaver.load_mobspawn_data()
	processing_queue = enemies_to_load
	remove_queue = enemies_to_unload
	set_process(true)

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

func _load_chests() -> void:
	var chest_data: Dictionary = GameStateSaver.load_chest_data()
	var chests: Array = get_tree().get_nodes_in_group("Chest")
	for chest in chests:
		if chest_data.get(chest.chest_id) != null:
			chest.item_container.items = chest_data.get(chest.chest_id).map(ItemManager.get_item_from_itemdata)

func _assign_mobspawns_to_dict() -> void:
	for mob_spawn_group in mob_spawns.get_children():
		if mob_spawn_group is MobTypePicker:
			for mob_spawn in mob_spawn_group.get_children():
				if mob_spawn is MobSpawn and not mob_spawn.disable_mob:
					_enemies[mob_spawn.spawn_id] = mob_spawn

func _spawn_world_loot() -> void:
	var event_data: Dictionary = GameStateSaver.load_world_event_data()
	for loot_container in world_loot.get_children():
		if loot_container is WorldLootContainer:
			if event_data:
				if event_data.get(loot_container.world_event_hash) != null:
					loot_container.event = true
					loot_container.disable_monitoring()
					continue

#func _spawn_mobs(reset_mobs: bool = false):
	#var mobspawn_data: Dictionary
	#if not reset_mobs:
		#mobspawn_data = GameStateSaver.load_mobspawn_data()
	#
	#for mob_spawn_group in mob_spawns.get_children():
		#if mob_spawn_group is MobTypePicker and not mob_spawn_group.disable_group:
			#for mob_spawn in mob_spawn_group.get_children():
				#if mob_spawn is MobSpawn and not mob_spawn.disable_mob:
					##print("spawn_name: ", mob_spawn.spawn_id)
					#if not reset_mobs and mobspawn_data:
						#if mobspawn_data.get(mob_spawn.spawn_id) != null:
							#if mobspawn_data.get(mob_spawn.spawn_id) == true:
								#mob_spawn.is_my_mob_dead = true
								#continue
					#var mob_instance = MobManager.spawn_mob_from_enum(mob_spawn_group.mob).instantiate()
					#if mob_instance:
						#mob_spawn.add_child(mob_instance)
						#if mob_spawn_group.mob != MobManager.MOBS.WASP:
							#mob_instance.global_position = Vector3(mob_instance.global_position.x, mob_instance.global_position.y + 5, mob_instance.global_position.z)
						#if not mob_instance.died.is_connected(mob_spawn.mob_died):
							#mob_instance.died.connect(mob_spawn.mob_died)

func _remove_mobs() -> void:
	for mob_spawn_group in mob_spawns.get_children():
		if mob_spawn_group is MobTypePicker:
			for mob_spawn in mob_spawn_group.get_children():
				if mob_spawn is MobSpawn:
					mob_spawn.is_my_mob_dead = false
					for mob in mob_spawn.get_children():
						mob.queue_free()

func _spawn_player():
	if not player:
		player = player_scene.instantiate()
		add_child(player)
	var player_data: Dictionary = GameStateSaver.get_player_data()
	if player_data:
		player.HEALTH = player_data.get("HEALTH") if player_data.get("HEALTH") else player.MAX_HEALTH
		player.STAMINA = player_data.get("STAMINA") if player_data.get("STAMINA") else player.MAX_STAMINA
		player.MANA = player_data.get("MANA") if player_data.get("MANA") else player.MAX_MANA
		if player_data.get("global_position"):
			player.global_position = player_data.get("global_position") + Vector3(0.0 , 0.2, 0.0)
		else:
			player.global_position = player_spawn.global_position + Vector3(0.0 , 0.2, 0.0)
		 
		#player.position_camera
		if player_data.get("global_rotation"):
			player.global_rotation = player_data.get("global_rotation")
			player.rotate_camera(player_data.get("global_rotation"))
		else:
			player.rotate_camera(player_spawn.global_rotation)
		
		#player.spirit = basic_player_resource.spirit
	else:
		player.global_position = player_spawn.global_position
	
	player.instantiate_data()
	
	if not player.spawn_projectile.is_connected(_spawn_projectile):
		player.spawn_projectile.connect(_spawn_projectile)
	if not player.died.is_connected(_player_died):
		player.died.connect(_player_died)

func _player_died() -> void:
	GameStateSaver.stop()
	game_menus.show_death_screen()
	_reset_mobs()
	_reset_player()
	WorldChunker.stop_rendering()
	CombatManager.clear_combat()
	GameStateSaver.save_next()

func _reset_mobs() -> void:
	GameStateSaver.reset_mob_data()
	_remove_mobs()

func _reset_player() -> void:
	player.reset_stats()
	GameStateSaver.reset_player_position(player_spawn)

func _continue_game() -> void:
	_spawn_player()
	WorldChunker.rechunk()
	GameStateSaver.start()
	game_menus.hide_death_screen()

func _exit_tree() -> void:
	GameStateSaver.stop()
	WorldChunker.stop_rendering()

extends Node

signal reload_enemies

var player: Player
var player_chunk: Vector2i

var grid_size: float = 20
var loaded_grid_size: int = 5

var enemy_spawns: Array[MobSpawn] #MobSpawn is just an extension of Marker3D with a couple extra properties, such as spawn_id (String) and is_my_mob_dead (bool)
var smallest_x: float = 0
var smallest_z: float = 0
var largest_x: float = 0
var largest_z: float = 0

var x_distance: float
var z_distance: float

var x_chunk_count: int
var z_chunk_count: int

var z_offset: float
var x_offset: float

var chunk_enemy_mapping: Dictionary[Vector2i, Array] = {}
var chunks_to_load: Array[Vector2i] = []
var currently_loaded_chunks: Array[Vector2i] = []

var time_goal_seconds: float = 2.5
var time_accumulator: float = 0

func _ready() -> void:
	set_physics_process(false)

func stop_rendering() -> void:
	set_physics_process(false)

func set_player(new_player: Player) -> void:
	player = new_player

func chunk(enemies: Array[MobSpawn]) -> void:
	chunk_enemy_mapping.clear()

	enemy_spawns = enemies
	if enemy_spawns.is_empty():
		push_error("enemy-list empty")
		return
	
	var first_pos: Vector3 = enemy_spawns[0].global_position
	smallest_x = first_pos.x
	smallest_z = first_pos.z
	largest_x = first_pos.x
	largest_z = first_pos.z
	
	for i in range(1, enemy_spawns.size()):
		var pos: Vector3 = enemy_spawns[i].global_position
	
		if smallest_x > pos.x:
			smallest_x = pos.x
		elif largest_x < pos.x:
			largest_x = pos.x
		if smallest_z > pos.z:
			smallest_z = pos.z
		elif largest_z < pos.z:
			largest_z = pos.z
	
	x_distance = largest_x - smallest_x
	z_distance = largest_z - smallest_z
	
	x_offset = 0 - smallest_x
	z_offset = 0 - smallest_z
	
	x_chunk_count = ceili(x_distance / grid_size)
	z_chunk_count = ceili(z_distance / grid_size)
	
	for enemy_spawn in enemy_spawns:
		
		var grid: Vector2i = _get_grid_from_position(enemy_spawn.global_position)
		
		if chunk_enemy_mapping.get(grid) == null:
			chunk_enemy_mapping[grid] = []
		chunk_enemy_mapping[grid].append(enemy_spawn)
	
	_set_player_chunk()
	_set_chunks_to_load()
	_reload_mobs()
	
	time_accumulator = 0
	set_physics_process(true)

func _get_grid_from_position(pos: Vector3) -> Vector2i:
	var x_pos_with_offset: float = pos.x + x_offset
	var z_pos_with_offset: float = pos.z + z_offset
	
	var grid_x: int = floori(x_pos_with_offset / grid_size)
	var grid_z: int = floori(z_pos_with_offset / grid_size)
	
	return Vector2i(grid_x, grid_z)

func _physics_process(delta: float) -> void:
	if not player:
		set_physics_process(false)
		push_error("player missing")
		return
	
	time_accumulator += delta
	if time_accumulator >= time_goal_seconds:
		time_accumulator = 0
		_set_player_chunk()
		_set_chunks_to_load()
		_reload_mobs()

func _set_player_chunk() -> void:
	player_chunk = _get_grid_from_position(player.global_position)

func _set_chunks_to_load() -> void:
	chunks_to_load.clear()
	
	var start_counter_x: int = player_chunk.x - floori(loaded_grid_size/2)
	var start_counter_z: int = player_chunk.y - floori(loaded_grid_size/2)
	
	for x in range(start_counter_x, start_counter_x + loaded_grid_size):
		if x < 0 or x > x_chunk_count:
			continue
		for z in range(start_counter_z, start_counter_z + loaded_grid_size):
			if z < 0 or z > z_chunk_count:
				continue
			var new_chunk: Vector2i = Vector2i(x, z)
			chunks_to_load.append(new_chunk)

func _reload_mobs() -> void:
	var mobspawns_to_load: Array[MobSpawn] = []
	for _chunk in chunks_to_load:
		if _chunk in currently_loaded_chunks:
			continue
		if chunk_enemy_mapping.get(_chunk) != null:
			mobspawns_to_load.append_array(chunk_enemy_mapping[_chunk])
	
	currently_loaded_chunks = chunks_to_load.duplicate()
	reload_enemies.emit(mobspawns_to_load)

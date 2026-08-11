extends Node

signal reload_enemies

var player: Player
var player_chunk: Vector2i

var grid_size: float = 25
var loaded_grid_size: int = 7

var enemy_spawns: Array[MobSpawn]

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
	
	for enemy_spawn in enemy_spawns:
		var grid: Vector2i = _get_grid_from_position(enemy_spawn.global_position)
		if not chunk_enemy_mapping.has(grid):
			chunk_enemy_mapping[grid] = []
		chunk_enemy_mapping[grid].append(enemy_spawn)
	
	rechunk()

func rechunk() -> void:
	currently_loaded_chunks = []
	chunks_to_load = []
	_set_player_chunk()
	_set_chunks_to_load()
	_reload_mobs()
	time_accumulator = 0
	set_physics_process(true)

func _get_grid_from_position(pos: Vector3) -> Vector2i:
	var grid_x: int = floori(pos.x / grid_size)
	var grid_z: int = floori(pos.z / grid_size)
	
	return Vector2i(grid_x, grid_z)

func _physics_process(delta: float) -> void:
	if not player:
		set_physics_process(false)
		push_error("player missing")
		return
	
	time_accumulator += delta
	if time_accumulator >= time_goal_seconds:
		_set_player_chunk()
		_set_chunks_to_load()
		_reload_mobs()
		time_accumulator = 0

func _set_player_chunk() -> void:
	player_chunk = _get_grid_from_position(player.global_position)

func _set_chunks_to_load() -> void:
	chunks_to_load.clear()
	
	var start_counter_x: int = player_chunk.x - floori(loaded_grid_size/2)
	var start_counter_z: int = player_chunk.y - floori(loaded_grid_size/2)
	
	for x in range(start_counter_x, start_counter_x + loaded_grid_size):
		for z in range(start_counter_z, start_counter_z + loaded_grid_size):
			var new_chunk: Vector2i = Vector2i(x, z)
			chunks_to_load.append(new_chunk)

func _reload_mobs() -> void:
	var mobspawns_to_load: Array[MobSpawn] = []
	var mobspawns_to_unload: Array[MobSpawn] = []
	for _chunk in chunks_to_load:
		if _chunk in currently_loaded_chunks:
			continue
		if chunk_enemy_mapping.get(_chunk) != null:
			mobspawns_to_load.append_array(chunk_enemy_mapping[_chunk])
	
	for _chunk in currently_loaded_chunks:
		if not _chunk in chunks_to_load:
			if chunk_enemy_mapping.has(_chunk):
				mobspawns_to_unload.append_array(chunk_enemy_mapping[_chunk])
	
	currently_loaded_chunks = chunks_to_load.duplicate()
	reload_enemies.emit(mobspawns_to_load, mobspawns_to_unload)

extends EnemyState

@export var bullet_position: Node
@export var cooldown_timer: Timer
@export var fire_rate: float = 0.01
@export var poison_burst_damage: int = 9
@export var hitbox_shape_radius: float = 0.5

@export_group("VFX")
@export var toxic_blast_vfx: PackedScene
@export var vfx_location: Node3D

var toxic_ground: PackedScene = preload("uid://4fwojmdcec7c")

var toxic_blast_instance: Basic_VFX

var fired: bool = false
var all_fired: bool = false
var first_exploded: bool = false
var target_location: Vector3
var fire_queue: int

var max_distance_to_enemy: float = 25000.0

var bomb_positions: Dictionary[int, Vector3]
var bomb_velocity: Dictionary[int, Vector3]
var bomb_rid_map: Dictionary[int, RID]
var rid_bomb_map: Dictionary[RID, int]
var impact_locations: Array[Vector3]

var time_accumulator: float =  0.0
var player_time_accumulator: float =  0.0
var player_check_rate: float = 0.5

var active_toxic_grounds: Array[DOT]
var active_toxic_ground_counter: int = 0
var all_dots_gone: bool = false

var projectile_speed: float = 25
var gravity_strength: float = 20
var spread: float = 12.0

var shape_rid: RID
var space_rid: RID
var area_rids: Array[RID]

func _ready() -> void:
	shape_rid = PhysicsServer3D.sphere_shape_create()
	PhysicsServer3D.shape_set_data(shape_rid, hitbox_shape_radius)
	space_rid = enemy.get_world_3d().space
	toxic_blast_instance = toxic_blast_vfx.instantiate()
	vfx_location.add_child(toxic_blast_instance)
	toxic_blast_instance.global_position = vfx_location.global_position - Vector3(0,1,0)

func _create_area() -> RID:
	var new_area: RID = PhysicsServer3D.area_create()
	PhysicsServer3D.area_add_shape(new_area, shape_rid)
	PhysicsServer3D.area_set_collision_mask(new_area, 7)
	PhysicsServer3D.area_set_space(new_area, space_rid)
	
	var callable_on_collision: Callable = Callable(self,"_bomb_collided").bind(new_area)
	
	PhysicsServer3D.area_set_monitor_callback(new_area, callable_on_collision)
	area_rids.append(new_area)
	return new_area

func Enter():
	super()
	time_accumulator = 0.0
	player_time_accumulator = 0.0
	active_toxic_grounds.clear()
	active_toxic_ground_counter = 0
	#AudioManager.play_audio_from_resource(audio_resource, enemy.global_position, AudioManager.BUS.SFX, offset_audio, audio_volume, audio_max_range)
	fired = false
	all_fired = false
	first_exploded = false
	all_dots_gone = false
	fire_queue = enemy.poison_blast_bullet_amount_new
	bomb_positions.clear()
	impact_locations.clear()
	target_location = Vector3(enemy.bomb_multi_mesh.position.x, enemy.bomb_multi_mesh.position.y + 20, enemy.bomb_multi_mesh.position.z)
	toxic_blast_instance.play()

func Exit():
	super()

func Physics_Update(delta: float) -> void:
	super(delta)
	if not fired:
		time_accumulator += delta
		if time_accumulator > fire_rate:
			time_accumulator = 0
			fire_queue -= 1
			if fire_queue < 0:
				fired = true
				return
			var spread_minus: float = 0-spread/2
			var spread_plus: float = 0+spread/2
			var this_target_location: Vector3 = Vector3(target_location.x + randf_range(spread_minus, spread_plus), target_location.y + randf_range(spread_minus, spread_plus), target_location.z + randf_range(spread_minus, spread_plus))
			var fire_direction: Vector3 = enemy.bomb_multi_mesh.position.direction_to(this_target_location)
			var start_position_transform: Transform3D = Transform3D(Basis(), bullet_position.global_position)
			var local_transform_start: Transform3D = enemy.bomb_multi_mesh.global_transform.affine_inverse() * start_position_transform
			
			bomb_positions[fire_queue] = fire_direction * projectile_speed
			bomb_velocity[fire_queue] = local_transform_start.origin
			bomb_rid_map[fire_queue] = _create_area()
			rid_bomb_map[bomb_rid_map[fire_queue]] = fire_queue
			PhysicsServer3D.area_set_transform(bomb_rid_map[fire_queue], start_position_transform)
			
			enemy.bomb_multi_mesh.multimesh.set_instance_transform(fire_queue, local_transform_start)
	if not all_fired:
		_move_bombs(delta)

#func _physics_process(delta: float) -> void:
	#if first_exploded and not all_dots_gone:
		#player_time_accumulator += delta
		#if player_time_accumulator > player_check_rate:
			#player_time_accumulator = 0
			#_check_player_position()

func _check_player_position():
	if active_toxic_ground_counter < 150:
		return
	impact_locations.sort_custom(sort_by_distance_to_player)
	var needed_locations: Array[Vector3] = impact_locations.slice(0, active_toxic_grounds.size())
	
	var unassigned_locations: Array[Vector3] = []
	var grounds_to_move: Array = []
	
	for ground in active_toxic_grounds:
		if not ground.global_position in needed_locations:
			grounds_to_move.append(ground)
	
	for location in needed_locations:
		var has_location: bool = false
		for ground in active_toxic_grounds:
			if ground.global_position.is_equal_approx(location):
				has_location = true
				break
		if not has_location:
			unassigned_locations.append(location)
	
	for i in range(unassigned_locations.size()):
		var ground: DOT = grounds_to_move[i]
		var callable: Callable = Callable(self, "move_ground").bind(ground, unassigned_locations[i])
		if not ground.faded.is_connected(callable):
			ground.faded.connect(callable)
		ground.fade_out()

func move_ground(ground: DOT, pos: Vector3) -> void:
	ground.global_position = pos
	ground.fade_in()

func sort_by_distance_to_player(a: Vector3, b: Vector3) -> bool:
	return a.distance_squared_to(player.global_position) < b.distance_squared_to(player.global_position)

func _move_bombs(delta: float) -> void:
	var bombs_to_remove: Array[int] = []
	for instance_id in bomb_positions:
		bomb_positions[instance_id].y -= gravity_strength * delta
		bomb_velocity[instance_id] += bomb_positions[instance_id] * delta    
		var current_transform: Transform3D = Transform3D(Basis(), bomb_velocity[instance_id])
		enemy.bomb_multi_mesh.multimesh.set_instance_transform(instance_id, current_transform)
		
		var new_global_transform: Transform3D = enemy.bomb_multi_mesh.global_transform * current_transform
		PhysicsServer3D.area_set_transform(bomb_rid_map[instance_id], new_global_transform)
		
		if new_global_transform.origin.distance_squared_to(enemy.global_position) > max_distance_to_enemy:
			bombs_to_remove.append(instance_id)
			#var rid: RID = bomb_rid_map.get(instance_id)
			#enemy.bomb_multi_mesh.multimesh.set_instance_transform(instance_id, Transform3D(Basis(), enemy.RESET_POSITION))
			#bomb_positions.erase(instance_id)
			#bomb_velocity.erase(instance_id)
			#bomb_rid_map.erase(instance_id)
			#rid_bomb_map.erase(rid)
			#area_rids.erase(rid)
			#
			#PhysicsServer3D.call_deferred("free_rid", rid)
	for bomb in bombs_to_remove:
		_cleanup_bomb(bomb)
	
	if bomb_positions.is_empty():
		all_fired = true
		cooldown_timer.start()
		
		_clear_ghost_rids()
		
		burst_finished()

func _clear_ghost_rids() -> void:
	for i in range(area_rids.size() - 1, -1, -1):
		var rid: RID = area_rids[i]
				
		if rid_bomb_map.has(rid):
			var bomb_id: int = rid_bomb_map[rid]
			bomb_velocity.erase(bomb_id)
			bomb_rid_map.erase(bomb_id)
			bomb_positions.erase(bomb_id)
			rid_bomb_map.erase(rid)
		
		PhysicsServer3D.call_deferred("free_rid", rid)
		area_rids.remove_at(i)

func burst_finished():
	Transitioned.emit(self, "Follow")

func _bomb_collided(_status: int, _body_rid: RID, object_id: int, _body_shape_idx: int, _self_shape_idx: int, area_rid: RID):
	first_exploded = true
	if not rid_bomb_map.has(area_rid):
		return
	
	var bomb_id: int = rid_bomb_map.get(area_rid)
	
	var nody: Node = instance_from_id(object_id)
	if nody is Player:
		nody.take_damage(poison_burst_damage, enemy, true, false)
		_cleanup_bomb(bomb_id)
		return
	else:
		pass
	var impact_location: Vector3 = (enemy.bomb_multi_mesh.global_transform * bomb_velocity[bomb_id]) + Vector3(0,1,0)
	impact_locations.append(impact_location)
	active_toxic_ground_counter += 1
	var toxic_ground_scene: DOT = ObjectPooler.get_free_toxic_ground()
	toxic_ground_scene.duration_timer.wait_time = 10
	
	if impact_location.distance_squared_to(player.global_position) < 15 and PlayerControls.is_position_in_frustrum(impact_location):
		toxic_ground_scene.activate(true)
	else:
		toxic_ground_scene.activate()
	toxic_ground_scene.global_position = impact_location
	
	var toxic_ground_finished_callable: Callable = Callable(self, "_reset_ground").bind(toxic_ground_scene)
	if not toxic_ground_scene.dot_finished.is_connected(toxic_ground_finished_callable):
		toxic_ground_scene.dot_finished.connect(toxic_ground_finished_callable)
	active_toxic_grounds.append(toxic_ground_scene)
	
	_cleanup_bomb(bomb_id)

func _cleanup_bomb(bomb_id: int) -> void:
	if not bomb_positions.has(bomb_id): 
		return
		
	var rid: RID = bomb_rid_map[bomb_id]
	
	enemy.bomb_multi_mesh.multimesh.set_instance_transform(bomb_id, Transform3D(Basis(), enemy.RESET_POSITION))
	
	bomb_positions.erase(bomb_id)
	bomb_velocity.erase(bomb_id)
	bomb_rid_map.erase(bomb_id)
	rid_bomb_map.erase(rid)
	area_rids.erase(rid)
	
	PhysicsServer3D.call_deferred("free_rid", rid)

func _reset_ground(toxic_ground_instance: DOT) -> void:
	ObjectPooler.reset_object(toxic_ground_instance)
	active_toxic_grounds.erase(toxic_ground_instance)
	active_toxic_ground_counter -= 1
	if active_toxic_ground_counter == 0:
		all_dots_gone = true

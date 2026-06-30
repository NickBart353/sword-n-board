extends EnemyState

@export var bullet_position: Node
@export var cooldown_timer: Timer
@export var fire_rate: float = 0.01
@export var poison_burst_damage: int = 9

@export var hitbox_shape_radius: float = 0.5

var toxic_ground: PackedScene = preload("uid://4fwojmdcec7c")

var fired: bool = false
var all_fired: bool = false
var target_location: Vector3
var fire_queue: int

var bomb_positions: Dictionary[int, Vector3]
var bomb_velocity: Dictionary[int, Vector3]
var bomb_rid_map: Dictionary[int, RID]
var rid_bomb_map: Dictionary[RID, int]

var time_accumulator: float =  0.0

var projectile_speed: float = 25
var gravity_strength: float = 20
var spread: float = 10.0

var shape_rid: RID
var space_rid: RID
var area_rids: Array[RID]

func _ready() -> void:
	shape_rid = PhysicsServer3D.sphere_shape_create()
	PhysicsServer3D.shape_set_data(shape_rid, hitbox_shape_radius)
	space_rid = enemy.get_world_3d().space

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
	AudioManager.play_audio_from_resource(audio_resource, enemy.global_position, AudioManager.BUS.SFX, offset_audio, audio_volume, audio_max_range)
	fired = false
	all_fired = false
	fire_queue = enemy.poison_blast_bullet_amount_new
	bomb_positions.clear()
	target_location = Vector3(enemy.bomb_multi_mesh.position.x, enemy.bomb_multi_mesh.position.y + 20, enemy.bomb_multi_mesh.position.z)

func Exit():
	super()

func Physics_Update(delta: float) -> void:
	super(delta)
	if not fired:
		time_accumulator += delta
		if time_accumulator > fire_rate:
			fire_queue -= 1
			for i in 5:
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

func _move_bombs(delta: float) -> void:
	for instance_id in bomb_positions:
		bomb_positions[instance_id].y -= gravity_strength * delta
		bomb_velocity[instance_id] += bomb_positions[instance_id] * delta    
		var current_transform: Transform3D = Transform3D(Basis(), bomb_velocity[instance_id])
		enemy.bomb_multi_mesh.multimesh.set_instance_transform(instance_id, current_transform)
		
		var new_global_transform: Transform3D = enemy.bomb_multi_mesh.global_transform * current_transform
		PhysicsServer3D.area_set_transform(bomb_rid_map[instance_id], new_global_transform)
	if bomb_positions.is_empty():
		all_fired = true
		cooldown_timer.start()
		
		_clear_ghost_rids()
		
		burst_finished()

func _clear_ghost_rids() -> void:
	for rid in area_rids:
		var bomb_id: int = rid_bomb_map[rid]
		bomb_velocity.erase(bomb_id)
		bomb_rid_map.erase(bomb_id)
		bomb_positions.erase(bomb_id)
		rid_bomb_map.erase(rid)
		
		PhysicsServer3D.call_deferred("free_rid", rid)
		area_rids.erase(rid)

func burst_finished():
	Transitioned.emit(self, "Follow")

func _bomb_collided(status: int, _body_rid: RID, object_id: int, _body_shape_idx: int, _self_shape_idx: int, area_rid: RID):
	if not rid_bomb_map.has(area_rid):
		return
	
	var bomb_id: int = rid_bomb_map.get(area_rid)
	
	
	if status == 1: #entered
		print("STATUS 1 ENTER")
	else: #exited
		print("STATUS 0 ENTER")
	
	var nody: Node = instance_from_id(object_id)
	if nody is Terrain3D:
		var toxic_ground_scene: DOT = toxic_ground.instantiate()
		bullet_position.add_child(toxic_ground_scene)
		toxic_ground_scene.activate()
		toxic_ground_scene.position = bomb_positions[bomb_id]
	elif nody is Player:
		nody.take_damage(poison_burst_damage, enemy, true, false)
	
	enemy.bomb_multi_mesh.multimesh.set_instance_transform(bomb_id, Transform3D(Basis(), enemy.RESET_POSITION))
	bomb_positions.erase(bomb_id)
	bomb_velocity.erase(bomb_id)
	bomb_rid_map.erase(bomb_id)
	rid_bomb_map.erase(area_rid)
	area_rids.erase(area_rid)
	
	PhysicsServer3D.call_deferred("free_rid", area_rid)

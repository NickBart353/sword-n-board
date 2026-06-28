extends EnemyState

@export var bullet_position: Node
@export var cooldown_timer: Timer
@export var fire_rate: float = 0.01
@export var poison_burst_damage: int = 9

@export var hitbox_shape_radius: float = 0.5

var fired: bool = false
var all_fired: bool = false
var target_location: Vector3
var fire_queue: int

var bomb_positions: Dictionary[int, Vector3]
var bomb_velocity: Dictionary[int, Vector3]

var time_accumulator: float =  0.0

var projectile_speed: float = 25
var gravity_strength: float = 20
var spread: float = 20.0

var shape_rid: RID
var space_rid: RID

func _ready() -> void:
	shape_rid = PhysicsServer3D.sphere_shape_create()
	PhysicsServer3D.shape_set_data(shape_rid, hitbox_shape_radius)
	#PhysicsServer3D.area_set_collision_mask(shape_rid, 2)
	#PhysicsServer3D.area_set_collision_mask(shape_rid, 3)
	space_rid = enemy.get_world_3d().space

func Enter():
	super()
	time_accumulator = 0.0
	AudioManager.play_audio_from_resource(audio_resource, enemy.global_position, AudioManager.BUS.SFX, offset_audio, audio_volume, audio_max_range)
	fired = false
	all_fired = false
	fire_queue = enemy.poison_blast_bullet_amount_new - 1
	bomb_positions.clear()
	target_location = Vector3(enemy.bomb_multi_mesh.position.x, enemy.bomb_multi_mesh.position.y + 20, enemy.bomb_multi_mesh.position.z)

func Exit():
	super()

func Physics_Update(delta: float) -> void:
	super(delta)
	if not fired:
		time_accumulator += delta
		if time_accumulator > fire_rate:
			for i in 5:
				var spread_minus: float = 0-spread/2
				var spread_plus: float = 0+spread/2
				var this_target_location: Vector3 = Vector3(target_location.x + randf_range(spread_minus, spread_plus), target_location.y + randf_range(spread_minus, spread_plus), target_location.z + randf_range(spread_minus, spread_plus))
				var fire_direction: Vector3 = enemy.bomb_multi_mesh.position.direction_to(this_target_location)
				var local_transform_start: Transform3D = enemy.bomb_multi_mesh.global_transform.affine_inverse() * Transform3D(Basis(), bullet_position.global_position)
				
				bomb_positions[fire_queue] = fire_direction * projectile_speed
				bomb_velocity[fire_queue] = local_transform_start.origin
				
				enemy.bomb_multi_mesh.multimesh.set_instance_transform(fire_queue, local_transform_start)
				fire_queue -= 1
				if fire_queue == 0:
					fired = true
					break
	if not all_fired:
		_move_bombs(delta)

func _move_bombs(delta: float) -> void:
	for instance_id in bomb_positions:
		bomb_positions[instance_id].y -= gravity_strength * delta
		bomb_velocity[instance_id] += bomb_positions[instance_id] * delta
		var current_transform: Transform3D = Transform3D(Basis(), bomb_velocity[instance_id])
		enemy.bomb_multi_mesh.multimesh.set_instance_transform(instance_id, current_transform)
	if bomb_positions.is_empty():
		all_fired = true
		cooldown_timer.start()
		burst_finished()

func burst_finished():
	Transitioned.emit(self, "Follow")

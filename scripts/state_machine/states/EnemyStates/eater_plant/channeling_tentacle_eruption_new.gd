extends EnemyChanneling

@export var rumbling_vfx: VfxManager.VFX = VfxManager.VFX.RUMBLING
@export var tentacle_multimesh: MultiMeshInstance3D

@export var rumbling_vfx_scene: PackedScene

var vfx_pool: Array[Basic_VFX]
var spike_positions: Array[Vector3]
var rumbling_vfx_instance: Node

func _ready() -> void:
	for i in range(enemy.tentacle_amount):
		var rumble_instance = VfxManager.create_vfx_from_enum(rumbling_vfx, Vector3.ZERO, true).instantiate()
		rumble_instance.vfx_finished.connect(_deactivate_vfx)#.bind(rumble_instance)
		vfx_pool.append(rumble_instance)
		call_deferred("add_child", rumble_instance)

func _deactivate_vfx(_vfx: Basic_VFX):
	pass

func Enter():
	super()
	spike_positions = []
	for i in enemy.tentacle_amount:
		var random_angle : float = randf_range(0, TAU)
		var random_distance : float = randf_range(enemy.tentacle_attack_min_radius, enemy.tentacle_attack_max_radius)
		var offset : Vector3 = Vector3.FORWARD.rotated(Vector3.UP, random_angle) * random_distance
		var spawn_pos : Vector3 = enemy.global_position + offset
		vfx_pool[i].global_position = spawn_pos
		spawn_pos.y -= randf_range(10, 15)
		
		ground_raycast.global_position = spawn_pos
		ground_raycast.force_raycast_update()
		
		if ground_raycast.get_collider() and ground_raycast.get_collider() is Terrain3D:
			spike_positions.append(spawn_pos)
			vfx_pool[i].play()

	spike_positions.sort_custom(_sort_by_distance_to_enemy)
	
	tentacle_multimesh.set_start_positions(spike_positions)

func _sort_by_distance_to_enemy(a: Vector3, b: Vector3) -> bool:
	return a.distance_squared_to(enemy.global_position) > b.distance_squared_to(enemy.global_position)

func Exit():
	super()

func Physics_Update(delta: float) -> void:
	super(delta)

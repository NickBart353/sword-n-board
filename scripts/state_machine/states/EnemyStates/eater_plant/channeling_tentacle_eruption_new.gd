extends EnemyChanneling

@export var rumbling_vfx: VfxManager.VFX = VfxManager.VFX.RUMBLING
@export var tentacle_multimesh: MultiMeshInstance3D

var vfx_pool: Array[Basic_VFX]
var spike_positions: Array[Vector3]

#func _ready() -> void:
	#for i in range(enemy.tentacle_amount):
		#var rumble_instance = VfxManager.create_vfx_from_enum(rumbling_vfx, Vector3.ZERO, true).instantiate()
		#vfx_pool.append(rumble_instance)
		#add_child.call_deferred(rumble_instance)

func Enter():
	super()
	spike_positions = []
	for i in enemy.tentacle_amount:
		var random_x : float = randf_range(- enemy.global_position.x - enemy.tentacle_spike_range, enemy.global_position.x - enemy.tentacle_spike_range)
		var random_y : float = randf_range(- enemy.global_position.y - 15, enemy.global_position.y - 15)
		var random_z : float = randf_range(- enemy.global_position.z - enemy.tentacle_spike_range, enemy.global_position.z - enemy.tentacle_spike_range)
		spike_positions.append(Vector3(random_x, random_y, random_z))
	
	spike_positions.sort_custom(_sort_by_distance_to_enemy)
	
	tentacle_multimesh.set_start_positions(spike_positions)
	
	#for i in enemy.tentacle_amount:
		#enemy.tentacle_spike_mesh.multimesh.set_instance_transform(i, Transform3D(Basis(), enemy.spike_positions[i]))

func _sort_by_distance_to_enemy(a: Vector3, b: Vector3) -> bool:
	return a.distance_squared_to(enemy.global_position) > b.distance_squared_to(enemy.global_position)

func Exit():
	super()

func Physics_Update(delta: float) -> void:
	super(delta)

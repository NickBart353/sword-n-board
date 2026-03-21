extends EnemyChanneling

@export var rumbling_vfx: VfxManager.VFX = VfxManager.VFX.RUMBLING

var vfx_pool: Array[Basic_VFX]

func _ready() -> void:
	for i in range(enemy.tentacle_amount):
		var rumble_instance = VfxManager.create_vfx_from_enum(rumbling_vfx, Vector3.ZERO, true).instantiate()
		vfx_pool.append(rumble_instance)
		add_child.call_deferred(rumble_instance)

func Enter():
	super()
	for i in range(enemy.tentacle_amount):
		var tentacle = enemy.tentacle_container.get_child(i)
		tentacle.set_deferred("process_mode", Node.PROCESS_MODE_INHERIT)
		tentacle.global_position = enemy.global_position + Vector3(randf_range(-enemy.tentacle_attack_max_radius, enemy.tentacle_attack_max_radius) + enemy.tentacle_attack_min_radius, -15, randf_range(-enemy.tentacle_attack_max_radius, enemy.tentacle_attack_max_radius) + enemy.tentacle_attack_min_radius)
		
		var vfx_pos: Vector3 = Vector3(tentacle.global_position.x, tentacle.global_position.y + 15, tentacle.global_position.z)
		vfx_pool[i].global_position = vfx_pos
		vfx_pool[i].play()
	#for tentacle in enemy.tentacle_container.get_children():
		#tentacle.set_deferred("process_mode", Node.PROCESS_MODE_INHERIT)
		#tentacle.global_position = enemy.global_position + Vector3(randf_range(-enemy.tentacle_attack_max_radius, enemy.tentacle_attack_max_radius) + enemy.tentacle_attack_min_radius, -15, randf_range(-enemy.tentacle_attack_max_radius, enemy.tentacle_attack_max_radius) + enemy.tentacle_attack_min_radius)
		

func Exit():
	super()

func Physics_Update(delta: float) -> void:
	super(delta)

extends EnemyChanneling

@export var rumbling_vfx: VfxManager.VFX = VfxManager.VFX.RUMBLING

func Enter():
	super()
	for tentacle in enemy.tentacle_container.get_children():
		tentacle.set_deferred("process_mode", Node.PROCESS_MODE_INHERIT)
		tentacle.global_position = enemy.global_position + Vector3(randf_range(-enemy.tentacle_attack_max_radius, enemy.tentacle_attack_max_radius) + enemy.tentacle_attack_min_radius, -15, randf_range(-enemy.tentacle_attack_max_radius, enemy.tentacle_attack_max_radius) + enemy.tentacle_attack_min_radius)
		var vfx_pos: Vector3 = Vector3(tentacle.global_position.x, tentacle.global_position.y + 15, tentacle.global_position.z)
		VfxManager.create_vfx_from_enum(rumbling_vfx, vfx_pos)

func Exit():
	super()

func Physics_Update(delta: float) -> void:
	super(delta)

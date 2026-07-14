extends EnemyChanneling

func Enter():
	super()

func Exit():
	super()

func Physics_Update(delta: float) -> void:
	super(delta)
	if vfx_instance and channeling_vfx_position:
		vfx_instance.global_position = channeling_vfx_position.global_position + vfx_offset

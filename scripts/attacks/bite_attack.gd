extends Attack

var vfx_instance: Basic_VFX

func _ready() -> void:
	super()
	vfx_instance = VfxManager.create_vfx_from_enum(VfxManager.VFX.CRUNCH_PARTICLES, self.global_position, true, global_rotation).instantiate()
	add_child(vfx_instance)

func play_crunch_vfx():
	vfx_instance.global_position = global_position
	vfx_instance.global_rotation = global_rotation
	vfx_instance.play()

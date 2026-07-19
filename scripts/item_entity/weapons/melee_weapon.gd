@abstract
class_name MeleeWeapon extends Weapon

@export var collision_point: Marker3D

func _ready() -> void:
	pass#print("{0}: Connect body entered signal!".format([self.name]))

func play_blood_vfx() -> void:
	var vfx: Basic_VFX = VfxPooler.get_free_vfx(VfxManager.VFX.BLOOD_SPLATTER)
	var callable: Callable = Callable(VfxPooler, "reset_object").bind(vfx)
	if not vfx.vfx_finished.is_connected(callable):
		vfx.vfx_finished.connect(callable)
	vfx.global_position = collision_point.global_position
	vfx.play()

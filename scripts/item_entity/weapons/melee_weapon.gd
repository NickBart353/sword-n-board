@abstract
class_name MeleeWeapon extends Weapon

@export var collision_point: Marker3D

signal hit

var ground_impact_vfx: Basic_VFX
var enemy_impact_vfx: Basic_VFX

func hit_body(body: Node3D) -> void:
	if body is Terrain3D:
		if not ground_impact_vfx:
			push_warning("ground impact null for ", data.item_name)
			return
		ground_impact_vfx.global_position = collision_point.global_position
		ground_impact_vfx.play()
	if body is Enemy:
		hit.emit(body, data.damage_resource)
		if not enemy_impact_vfx:
			push_warning("enemy impact null for ", data.item_name)
			return
		enemy_impact_vfx.global_position = collision_point.global_position
		enemy_impact_vfx.play()

func _ready() -> void:
	ground_impact_vfx = VfxManager.VFX_DICT[VfxManager.VFX.DIRT_EXPLOSION].instantiate()
	add_child.call_deferred(ground_impact_vfx)
	ground_impact_vfx.hide()
	if not ground_impact_vfx.vfx_finished.is_connected(_reset_impact_vfx):
		ground_impact_vfx.vfx_finished.connect(_reset_impact_vfx)
	#print("{0}: Connect body entered signal!".format([self.name]))

func play_enemy_impact_vfx() -> void:
	if enemy_impact_vfx == null:
		push_error("enemy_impact_vfx not set for: ", data.item_name)
		return
	if collision_point == null:
		push_error("collision point not set for: ", data.item_name)
		return
	
	enemy_impact_vfx.global_position = collision_point.global_position
	enemy_impact_vfx.show()
	enemy_impact_vfx.restart()

func play_blood_vfx() -> void:
	push_error("melee_weapon.gd . remove play blood vfx from this weapon ", data.item_name)
	pass
	#var vfx: Basic_VFX = VfxPooler.get_free_vfx(VfxManager.VFX.BLOOD_SPLATTER)
	#var callable: Callable = Callable(VfxPooler, "reset_object").bind(vfx)
	#if not vfx.vfx_finished.is_connected(callable):
		#vfx.vfx_finished.connect(callable)
	#vfx.global_position = collision_point.global_position
	#vfx.play()

func _reset_impact_vfx(vfx: Basic_VFX) -> void:
	vfx.hide()

func set_impact_vfx(new_impact_vfx: PackedScene) -> void:
	enemy_impact_vfx = new_impact_vfx.instantiate()
	add_child.call_deferred(enemy_impact_vfx)
	enemy_impact_vfx.hide()
	if not enemy_impact_vfx.vfx_finished.is_connected(_reset_impact_vfx):
		enemy_impact_vfx.vfx_finished.connect(_reset_impact_vfx)

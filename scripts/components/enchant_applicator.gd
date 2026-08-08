@tool
class_name EnchantApplicator extends Node3D

const enchant_dict: Dictionary = {
	WeaponData.UPGRADE_TYPE.FIRE: {
		"particle_effect": preload("uid://x3push4qk0sw"),
		"secondary_material": preload("uid://iusm2407qbr7"),
		#"color": Color(2.138, 0.589, 0.0),
		"material": preload("uid://vaslxn8b248n"),
	},
	WeaponData.UPGRADE_TYPE.COLD: {
		"particle_effect": preload("uid://bjrhh5siikley"),
		"secondary_material": preload("uid://iusm2407qbr7"),
		"material": preload("uid://dxbq8puoe40kr"),
	},
	WeaponData.UPGRADE_TYPE.CHAOS: {
		"particle_effect": preload("uid://jw3d2cr1nd4w"),
		"secondary_material": preload("uid://iusm2407qbr7"),
		"material": preload("uid://7npcv6sj7ix4"),
	},
	WeaponData.UPGRADE_TYPE.LIGHTNING: {
		"particle_effect": preload("uid://bdfob8dt2wm6s"),
		"secondary_material": preload("uid://iusm2407qbr7"),
		"material": preload("uid://sqjgjbnxnctw"),
	},
	WeaponData.UPGRADE_TYPE.NATURE: {
		"particle_effect": preload("uid://de7ukko2cqb7j"),
		"secondary_material": preload("uid://iusm2407qbr7"),
		"material": preload("uid://dhbanvubj8m0g"),
	},
	"default-dagger": {
		"color": Color("9a9a9a"),
	},
}

@export var weapon: MeleeWeapon
@export var particle_effect: GPUParticles3D #export feature is for debug
@export var weapon_mesh: MeshInstance3D

@export_group("Magic Settings")
@export_group("Fire Settings")
@export var fire_particle_amount: int = 50
@export var fire_mesh_surface_indexes: Array[int] = []
@export var fire_secondary_mesh_surface_indexes: Array[int] = []
@export var fire_emission_shape: CollisionShape3D
@export_group("Cold Settings")
@export var cold_particle_amount: int = 50
@export var cold_mesh_surface_indexes: Array[int] = []
@export var cold_secondary_mesh_surface_indexes: Array[int] = []
@export var cold_emission_shape: CollisionShape3D
@export_group("Lightning Settings")
@export var lightning_particle_amount: int = 50
@export var lightning_mesh_surface_indexes: Array[int] = []
@export var lightning_secondary_mesh_surface_indexes: Array[int] = []
@export var lightning_emission_shape: CollisionShape3D
@export_group("Nature Settings")
@export var nature_particle_amount: int = 50
@export var nature_mesh_surface_indexes: Array[int] = []
@export var nature_secondary_mesh_surface_indexes: Array[int] = []
@export var nature_emission_shape: CollisionShape3D
@export_group("Chaos Settings")
@export var chaos_particle_amount: int = 50
@export var chaos_mesh_surface_indexes: Array[int] = []
@export var chaos_secondary_mesh_surface_indexes: Array[int] = []
@export var chaos_emission_shape: CollisionShape3D

var upgrade_type: WeaponData.UPGRADE_TYPE
var vfx_instance: GPUParticles3D

#enum UPGRADE_TYPE {MAGIC}

func _ready() -> void:
	if not weapon or not weapon_mesh:
		push_error("enchant component not correctly set up for: ", get_parent().data.item_name)
		return
	
	upgrade_type = weapon.data.upgrade_type
	
	if upgrade_type == WeaponData.UPGRADE_TYPE.NORMAL:
		return
	
	match upgrade_type:
		WeaponData.UPGRADE_TYPE.FIRE:
			_apply_enchant(fire_particle_amount, fire_mesh_surface_indexes, fire_secondary_mesh_surface_indexes, fire_emission_shape)
		WeaponData.UPGRADE_TYPE.COLD:
			_apply_enchant(cold_particle_amount, cold_mesh_surface_indexes, cold_secondary_mesh_surface_indexes, cold_emission_shape)
		WeaponData.UPGRADE_TYPE.LIGHTNING:
			_apply_enchant(lightning_particle_amount, lightning_mesh_surface_indexes, lightning_secondary_mesh_surface_indexes, lightning_emission_shape)
		WeaponData.UPGRADE_TYPE.NATURE:
			_apply_enchant(nature_particle_amount, nature_mesh_surface_indexes, nature_secondary_mesh_surface_indexes, nature_emission_shape)
		WeaponData.UPGRADE_TYPE.CHAOS:
			_apply_enchant(chaos_particle_amount, chaos_mesh_surface_indexes, chaos_secondary_mesh_surface_indexes, chaos_emission_shape)
	

func _apply_enchant(particle_amount: int, mesh_surface_indexes: Array[int], secondary_mesh_surface_indexes: Array[int], emission_shape: CollisionShape3D) -> void:
	if not emission_shape or not emission_shape.shape is BoxShape3D:
		push_error("emission shape not correctly set up for: ", weapon.data.item_name, " Upgrade type", upgrade_type)
		return
	
	vfx_instance = enchant_dict[upgrade_type]["particle_effect"].instantiate()
	add_child(vfx_instance)
	
	vfx_instance.amount = particle_amount
	vfx_instance.rotation = emission_shape.rotation
	vfx_instance.process_material.emission_shape_offset = emission_shape.position
	vfx_instance.process_material.emission_box_extents = emission_shape.shape.size
	
	for index in mesh_surface_indexes:
		if enchant_dict[upgrade_type].has("material"):
			weapon_mesh.mesh.surface_set_material(index, enchant_dict[upgrade_type]["material"])
		else:
			var material: StandardMaterial3D = weapon_mesh.mesh.surface_get_material(index)
			material.albedo_color = enchant_dict[upgrade_type]["color"]
	
	for index in secondary_mesh_surface_indexes:
		if enchant_dict[upgrade_type].has("secondary_material"):
			weapon_mesh.mesh.surface_set_material(index, enchant_dict[upgrade_type]["secondary_material"])

@tool
class_name EnchantApplicator extends Node3D

const enchant_dict: Dictionary = {
	WeaponData.UPGRADE_TYPE.FIRE: {
		"particle_effect": preload("uid://x3push4qk0sw"),
		"color": Color(2.138, 0.589, 0.0),
	}
}

enum AMOUNT {small, medium, large}

@export var weapon: MeleeWeapon
@export var particle_effect: GPUParticles3D #export feature is for debug
@export var particle_amount: AMOUNT = AMOUNT.small
@export var weapon_mesh: MeshInstance3D
@export var mesh_surface_indexes: Array[int] = []
@export_group("Emission Shapes")
@export var fire_emission_shape: CollisionShape3D

var upgrade_type: WeaponData.UPGRADE_TYPE
var vfx_instance: GPUParticles3D
var emission_shape: CollisionShape3D

#enum UPGRADE_TYPE {NORMAL, MAGIC, FIRE, LIGHTNING, COLD, NATURE, CHAOS}

func _ready() -> void:
	if not weapon or not weapon_mesh or not mesh_surface_indexes:
		push_error("enchant component not correctly set up for: ", get_parent().data.item_name)
		return
	
	upgrade_type = weapon.data.upgrade_type
	
	if upgrade_type == WeaponData.UPGRADE_TYPE.NORMAL:
		return
	
	match upgrade_type:
		WeaponData.UPGRADE_TYPE.FIRE:
			emission_shape = fire_emission_shape
	
	if not emission_shape or not emission_shape.shape is BoxShape3D:
		push_error("emission shape not correctly set up for: ", weapon.data.item_name, "Upgrade type", upgrade_type)
		return
	
	vfx_instance = enchant_dict[upgrade_type]["particle_effect"].instantiate()
	add_child(vfx_instance)
	
	
	match particle_amount:
		AMOUNT.small:
			vfx_instance.amount = 50
		AMOUNT.medium:
			vfx_instance.amount = 100
		AMOUNT.large:
			vfx_instance.amount = 200
	vfx_instance.process_material.emission_shape_offset = emission_shape.position
	vfx_instance.process_material.emission_box_extents = emission_shape.shape.size
	
	for index in mesh_surface_indexes:
		var material: StandardMaterial3D = weapon_mesh.mesh.surface_get_material(index)
		material.albedo_color = enchant_dict[upgrade_type]["color"]
	
	#TODO - MAYBE:
	#potentially apply (not yet implemented)shader with said color to mesh

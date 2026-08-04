@tool
extends Node3D

@export var weapon: MeleeWeapon
@export var emission_shape: CollisionShape3D
@export var particle_effect: GPUParticles3D #export feature is for debug
@export var weapon_mesh: MeshInstance3D
@export var mesh_component_names: Array[String]

const enchant_dict: Dictionary = {
	"fire": {
		"particle_effect": "",
		"color": Color(2.138, 0.589, 0.0),
	}
}

func _ready() -> void:
	pass
	#TODO:
	#add particle effect as child
	#get shape from collisionshape
	#set shape to particle system spawn location
	#change weapon mesh color to enchanted one 
	#potentially apply (not yet implemented)shader with said color to mesh

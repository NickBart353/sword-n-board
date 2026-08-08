@tool
extends Node3D

@export var flame_color: Color
@export var smoke_color: Color
@export var particle_color: Color
@export var see_through_objects: bool = false

@export var update_colors: bool = false : set = _update_colors

var shader_normal = preload("res://shaders/fire/vfx_fire_depth_test_DISABLED.tres")
var shader_see_through = preload("res://shaders/fire/vfx_fire_depth_test_ENABLED.tres")

func _update_colors(_val: bool) -> void:
	_update_color()

func _ready() -> void:
	#if $Flames.process_material:
		#$Flames.process_material = $Flames.process_material.duplicate()
		#$Flames.material_override = $Flames.material_override.duplicate()
	#
	#if $Smoke.process_material:
		#$Smoke.process_material = $Smoke.process_material.duplicate()
		#$Smoke.material_override = $Smoke.material_override.duplicate()
	#
	#if $FloatingParticles.process_material:
		#$FloatingParticles.process_material = $FloatingParticles.process_material.duplicate()
	#
	_update_color()

func _update_color():
	$Flames.process_material.color = flame_color
	$Smoke.process_material.color = smoke_color
	$FloatingParticles.process_material.color = particle_color
	
	if see_through_objects:
		$Flames.material_override.shader = shader_normal
		$Smoke.material_override.shader = shader_normal
	else:
		$Flames.material_override.shader = shader_see_through
		$Smoke.material_override.shader = shader_see_through

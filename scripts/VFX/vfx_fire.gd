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
	_update_color(flame_color, smoke_color, particle_color)

func update_all_colors(_flame_color: Color, _smoke_color: Color, _particle_color: Color) -> void:
	_update_color(_flame_color, _smoke_color, _particle_color)

func _ready() -> void:
	_update_color(flame_color, smoke_color, particle_color)

func _update_color(_flame_color: Color, _smoke_color: Color, _particle_color: Color):
	$Flames.process_material.color = _flame_color
	$Smoke.process_material.color = _smoke_color
	$FloatingParticles.process_material.color = _particle_color
	
	if see_through_objects:
		$Flames.material_override.shader = shader_normal
		$Smoke.material_override.shader = shader_normal
	else:
		$Flames.material_override.shader = shader_see_through
		$Smoke.material_override.shader = shader_see_through

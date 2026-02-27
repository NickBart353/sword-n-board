extends Node3D
class_name Projectile

@export var projectile_area: Area3D
@export var explosion_area: Area3D
@export var explosion_radius: float = 1.0
@export var proj_speed = 30
@export var proj_distance = 100
@export var gravity_strength: float = 0.0
@export var spread: float = 0.0
@export var explosion_animation: VfxManager.VFX
@export var damage: int = 10
@export var explosion_target_raycast: RayCast3D


signal exploded

enum TARGET {ENEMY, PLAYER}

var velocity: Vector3 = Vector3.ZERO
var fire_direction: Vector3 = Vector3.ZERO
var ready_to_fly: bool = false
var target_hit: bool = false
var hit: bool = false
var explosion_hit: bool = false
var new_transform: Transform3D = Transform3D.IDENTITY
var hit_by_explosion_list: Array = []
var origin: Vector3

func _ready() -> void:
	projectile_area.body_entered.connect(_on_body_entered)
	projectile_area.area_entered.connect(_on_area_entered)
	explosion_area.body_entered.connect(_on_explosion_body_entered)
	explosion_area.area_entered.connect(_on_explosion_area_entered)

func _physics_process(delta: float) -> void:
	if not ready_to_fly: return
	if origin.distance_to(global_position) > proj_distance: _hit_object()
	global_basis = new_transform.basis.orthonormalized()
	velocity.y -= gravity_strength * delta
	global_translate(velocity * delta)

func _on_body_entered(body: Node3D) -> void:
	if hit or body in hit_by_explosion_list: return
	if (body is Player or body is Enemy) and not target_hit:
		was_object_hit_first(body, projectile_area.get_children()[0].shape.radius)
		target_hit = true
	_hit_object()
	hit_by_explosion_list.append(body)

func _on_area_entered(_area: Area3D) -> void:
	if hit: return
	if _area.is_in_group("Shield"):
		target_hit = true
	_hit_object()

func _on_explosion_body_entered(body: Node3D) -> void:
	if body in hit_by_explosion_list: return
	if (body is Player or body is Enemy):# and not target_hit:
		was_object_hit_first(body, explosion_radius)
		target_hit = true
	hit_by_explosion_list.append(body)

func _on_explosion_area_entered(_area: Area3D) -> void:
	pass#if explosion_hit: return
	#explosion_area.set_deferred("monitoring", false)
	#explosion_hit = true

func was_object_hit_first(object: Node, raycast_length: float):
	#explosion_target_raycast.target_position = (object.global_position - global_position).normalized() * raycast_length
	var local_target = explosion_target_raycast.to_local(object.global_position)
	explosion_target_raycast.target_position = local_target.normalized() * raycast_length
	explosion_target_raycast.force_raycast_update()
	var first_hit_object = explosion_target_raycast.get_collider()
	if (first_hit_object and (first_hit_object is Player or first_hit_object is Enemy)) or not first_hit_object:
		object.take_damage(damage, explosion_area)

func _hit_object():
	ready_to_fly = false
	VfxManager.create_vfx_from_enum(explosion_animation, global_position)
	hit = true
	set_physics_process(false) 
	projectile_area.set_deferred("monitoring", false)
	explosion_area.set_deferred("monitoring", true)
	var tween = create_tween()
	tween.finished.connect(_explode)
	tween.tween_property(explosion_area.get_children()[0].shape, "radius", explosion_radius, 0.1)

func _explode():
	for node in get_children():
		if node is GPUParticles3D:
			node.emitting = false
			node.set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)
	exploded.emit(self)

func fire(my_position: Vector3, target_location: Vector3, proj_transform: Transform3D, direction_flag: bool = false):
	set_physics_process(true) 
	explosion_area.get_children()[0].shape.radius = 0.1
	projectile_area.set_deferred("monitoring", true)
	explosion_area.set_deferred("monitoring", false)
	new_transform = proj_transform
	hit = false
	explosion_hit = false
	global_position = my_position
	for node in get_children():
		if node is GPUParticles3D:
			node.emitting = true
			node.set_deferred("process_mode", Node.PROCESS_MODE_INHERIT)
	hit_by_explosion_list = []
	origin = my_position
	if not direction_flag:
		if spread:
			var spread_minus: float = 0-spread/2
			var spread_plus: float = 0+spread/2
			target_location = Vector3(target_location.x + randf_range(spread_minus, spread_plus), target_location.y + randf_range(spread_minus, spread_plus), target_location.z + randf_range(spread_minus, spread_plus))
		fire_direction = my_position.direction_to(target_location)
		velocity = fire_direction * proj_speed
		ready_to_fly = true
	else:
		if spread:
			var spread_minus: float = 0-spread/2
			var spread_plus: float = 0+spread/2
			target_location = Vector3(target_location.x + randf_range(spread_minus, spread_plus), target_location.y + randf_range(spread_minus, spread_plus), target_location.z + randf_range(spread_minus, spread_plus))
		fire_direction = target_location
		velocity = fire_direction * proj_speed
		ready_to_fly = true

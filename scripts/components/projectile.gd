extends Node3D
class_name Projectile

@export var projectile_area: Area3D
@export var explosion_area: Area3D
@export var proj_speed = 30
@export var gravity_enabled: bool = false
@export var spread: float = 0.0
@export var explosion_animation: VfxManager.VFX
@export var damage: int = 10

signal exploded

enum TARGET {ENEMY, PLAYER}

var velocity: Vector3 = Vector3.ZERO
var fire_direction: Vector3 = Vector3.ZERO
var ready_to_fly: bool = false
var target_hit: bool = false
var hit: bool = false
var gravity: float

func _ready() -> void:
	projectile_area.body_entered.connect(_on_body_entered)
	projectile_area.area_entered.connect(_on_area_entered)
	if not gravity_enabled:
		gravity = 0  
	else:
		gravity = 9.81

func _physics_process(delta: float) -> void:
	if hit:
		for body in explosion_area.get_overlapping_bodies():
			if (body is Player or body is Enemy) and not target_hit:
				body.take_damage(damage)
				target_hit = true
		for area in explosion_area.get_overlapping_areas():
			pass
		exploded.emit(self)
	
	if not ready_to_fly: return
	velocity.y -= gravity * delta
	global_translate(velocity * delta)

func _on_body_entered(body: Node3D) -> void:
	if (body is Player or body is Enemy) and not target_hit:
		body.take_damage(damage)
		target_hit = true
	ready_to_fly = false
	VfxManager.create_vfx_from_enum(explosion_animation, global_position)
	hit = true

func _on_area_entered(_area: Area3D) -> void:
	ready_to_fly = false
	VfxManager.create_vfx_from_enum(explosion_animation, global_position)
	hit = true

func fire(my_position: Vector3, target_location: Vector3):
	hit = false
	global_position = my_position
	
	if spread:
		var spread_minus: float = 0-spread/2
		var spread_plus: float = 0+spread/2
		target_location = Vector3(target_location.x + randf_range(spread_minus, spread_plus), target_location.y + randf_range(spread_minus, spread_plus), target_location.z + randf_range(spread_minus, spread_plus))
	fire_direction = my_position.direction_to(target_location)
	velocity = fire_direction * proj_speed
	ready_to_fly = true

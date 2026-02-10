extends Area3D
class_name PoisonBomb

@export var bomb_speed = 30

signal exploded

var velocity: Vector3 = Vector3.ZERO
var fire_direction: Vector3 = Vector3.ZERO
var damage: int = 10
var ready_to_fly: bool = false
var player_hit: bool = false
var hit: bool = false

func _physics_process(delta: float) -> void:
	if hit:
		for body in $ExplosionArea.get_overlapping_bodies():
			if body is Player and not player_hit:
				body.take_damage(damage, self)
				player_hit = true
		for area in $ExplosionArea.get_overlapping_areas():
			pass
		exploded.emit(self)
	
	if not ready_to_fly: return
	velocity.y -= get_gravity() * delta
	global_translate(velocity * delta)

func _on_body_entered(body: Node3D) -> void:
	if body is Enemy: return
	if body is Player and not player_hit:
		body.take_damage(damage, self)
		player_hit = true
	ready_to_fly = false
	VfxManager.create_poison_explosion(global_position)
	hit = true

func _on_area_entered(area: Area3D) -> void:
	if area is PoisonBomb or area.name == "ExplosionArea" or area.is_in_group("Enemy_Part"): return
	ready_to_fly = false
	VfxManager.create_poison_explosion(global_position)
	hit = true

func fire(my_position: Vector3, player_location: Vector3):
	hit = false
	global_position = my_position
	var player_loc_spread: Vector3 = Vector3(player_location.x + randi_range(-10, 10), player_location.y + randi_range(-5, 5), player_location.z + randi_range(-5, 5))
	fire_direction = my_position.direction_to(player_loc_spread)
	velocity = fire_direction * bomb_speed
	ready_to_fly = true

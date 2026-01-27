extends Area3D
class_name PoisonBomb

@export var bomb_speed = 30

signal exploded

var velocity: Vector3 = Vector3.ZERO
var fire_direction: Vector3 = Vector3.ZERO
var damage: int = 10
var ready_to_fly: bool = false

func _physics_process(delta: float) -> void:
	if not ready_to_fly: return
	velocity.y -= get_gravity() * delta
	global_translate(velocity * delta)

func _on_body_entered(body: Node3D) -> void:
	if body is Enemy: return
	if body is Player:
		body.take_damage(damage, self)
	ready_to_fly = false
	VfxManager.create_poison_explosion(global_position)
	$CollisionShape3D.shape.radius = 0.5
	exploded.emit(self)

func _on_area_entered(area: Area3D) -> void:
	if area is PoisonBomb: return
	ready_to_fly = false
	VfxManager.create_poison_explosion(global_position)
	$CollisionShape3D.shape.radius = 1
	exploded.emit(self)

func fire(my_position: Vector3, _wasp_position: Vector3, player_location: Vector3):
	$CollisionShape3D.shape.radius = 0.5
	global_position = my_position
	var player_loc_spread: Vector3 = Vector3(player_location.x + randi_range(-10, 10), player_location.y + randi_range(-5, 5), player_location.z + randi_range(-5, 5))
	fire_direction = my_position.direction_to(player_loc_spread)
	velocity = fire_direction * bomb_speed
	ready_to_fly = true

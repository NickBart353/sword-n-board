extends Node

@export var player: CharacterBody3D
@export var movement_speed: int = 5
@export var jump_velocity: int = 5
@export var dash_speed: int = 50
@export var dash_distance: int = 10

var dashing: bool
var dashing_direction: Vector3
var dashing_origin: Vector3

func apply_movement(input: Node, delta: float) -> void:
	if not input.dash and not dashing:
		var move_dir := (player.transform.basis * Vector3(input.direction.x, 0, input.direction.y)).normalized()
		if move_dir:
			player.velocity.x = move_dir.x * movement_speed
			player.velocity.z = move_dir.z * movement_speed
		else:
			player.velocity.x = move_toward(player.velocity.x, 0, movement_speed)
			player.velocity.z = move_toward(player.velocity.z, 0, movement_speed)
		
		if not player.is_on_floor():
			player.velocity += player.get_gravity() * delta
		if player.is_on_floor() and input.jump:
			player.velocity.y += jump_velocity
	else:
		if not dashing:
			dashing_origin = player.global_position
			if not input.direction:
				dashing_direction = $"../Head/FieldOfView".get_global_transform().basis.z
				dashing_direction.z *= -1
				dashing_direction.x *= -1
				dashing_direction.y = 0
				dashing_direction = dashing_direction.normalized()
			else:
				dashing_direction = Vector3(player.input.direction.x, 0, player.input.direction.y)
				dashing_direction = (player.transform.basis * Vector3(dashing_direction.x, 0, dashing_direction.z)).normalized()
		player.velocity = dashing_direction * dash_speed
		if player.global_position.distance_to(dashing_origin) > dash_distance:
			dashing = false

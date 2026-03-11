extends Node

@export var player: CharacterBody3D
@export var movement_speed: int = 5
@export var jump_velocity: int = 5
@export var dash_speed: int = 50
@export var dash_distance: int = 10

var dashing: bool
var jumping: bool
var moving: bool
var falling: bool
var dashing_direction: Vector3
var dashing_origin: Vector3

func apply_movement(input: Node, state_controller: Node, delta: float) -> void:
	if not input.dash and not dashing:
		var move_dir := (player.transform.basis * Vector3(input.direction.x, 0, input.direction.y)).normalized()
		if move_dir and not jumping and not falling:
			moving = true
			player.velocity.x = move_dir.x * movement_speed
			player.velocity.z = move_dir.z * movement_speed
			player.velocity.y = get_proper_vertical_velocity(input.direction, delta)
			
		elif not move_dir and not jumping:
			moving = false
			player.velocity.x = move_toward(player.velocity.x, 0, movement_speed)
			player.velocity.z = move_toward(player.velocity.z, 0, movement_speed)
		
		if not player.is_on_floor():
			player.velocity += player.get_gravity() * delta
			falling = true
		if jumping and player.is_on_floor():
			jumping = false
		if player.is_on_floor() and input.jump:
			player.velocity.y = jump_velocity
			jumping = true
		if player.is_on_floor() and falling:
			falling = false
	else:
		if not dashing:
			dashing = true
			dashing_origin = player.global_position
			if not input.direction:
				dashing_direction = player.get_camera_transform().basis.z
				dashing_direction.z *= -1
				dashing_direction.x *= -1
				dashing_direction.y = 0
				dashing_direction = dashing_direction.normalized()
			else:
				dashing_direction = Vector3(player.input.direction.x, 0, player.input.direction.y)
				dashing_direction = (player.transform.basis * Vector3(dashing_direction.x, 0, dashing_direction.z)).normalized()
		player.velocity = dashing_direction * dash_speed
		if player.global_position.distance_to(dashing_origin) > dash_distance or player.is_on_wall():
			dashing = false
			player.velocity.x = 0
			player.velocity.z = 0
			if not player.is_on_floor():
				falling = true

func get_proper_vertical_velocity(move_direction: Vector2, delta: float) -> float:
	if not move_direction.x and not move_direction.y:
		return player.velocity.y
	match move_direction.x:
		1.0:
			return _check_raycast("Right", delta)
		-1.0:
			return _check_raycast("Left", delta)
	match move_direction.y:
		1.0:
			return _check_raycast("Back", delta)
		-1.0:
			return _check_raycast("Front", delta)
	return player.velocity.y

func _check_raycast(direction: String, delta):
	var raycast_container: Node3D = player.get_directional_raycasts()
	var directional_ray: RayCast3D = raycast_container.get_node(direction)
	var down: RayCast3D = raycast_container.get_node("Down")
	var directional_normal: Vector3 = directional_ray.get_collision_point()
	var down_normal: Vector3 = down.get_collision_point()
	if down_normal.y > directional_normal.y:
		return -3 + player.get_gravity().y * delta
	else:
		return player.velocity.y

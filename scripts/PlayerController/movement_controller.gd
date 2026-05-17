class_name PlayerMovementController extends Node

signal update_rotation_modifier

@export var player: CharacterBody3D
@export var movement_speed: int = 5
@export var jump_velocity: int = 5
@export var dash_speed: int = 50
@export var dash_distance: int = 10
@export_range(0.0, 5.0) var falling_time_threshold: float = 0.5

@export_group("StaminaCost")
@export_range(0.0, 100.0) var jump_cost = 15.0
@export_range(0.0, 100.0) var dash_cost = 25.0

const MOVEMENT_MODIFIER_DICT_PRESET: Dictionary = {
	"amount": 0.0,
	"type": "",
}

var dashing: bool
var dash_started: bool
var jumping: bool
var moving: bool
var falling: bool
var landed: bool
var is_on_floor: bool

var dashing_direction: Vector3
var dashing_origin: Vector3

var air_time: float = 0.0

var calculated_movement_speed: float = 1
var calculated_movement_modifiers: float = 1
var movement_modifiers: Array[Dictionary] = []

var calculated_rotation_modifiers: float = 1
var rotation_modifiers: Array[Dictionary] = []

func _ready() -> void:
	calculated_movement_speed = movement_speed

func apply_movement(input: Node, state_controller: Node, ability_controller: Node, delta: float) -> void:
	dash_started = false
	if not input.dash and not dashing:
		var move_dir := (player.transform.basis * Vector3(input.direction.x, 0, input.direction.y)).normalized()
		if move_dir and not jumping and not falling:
			moving = true
			player.velocity.x = move_dir.x * calculated_movement_speed 
			player.velocity.z = move_dir.z * calculated_movement_speed 
			player.velocity.y = get_proper_vertical_velocity(input.direction, delta)
			
		elif not move_dir and not jumping:
			moving = false
			player.velocity.x = move_toward(player.velocity.x, 0, movement_speed)
			player.velocity.z = move_toward(player.velocity.z, 0, movement_speed)
		
		if not player.is_on_floor():
			air_time += delta
			player.velocity += player.get_gravity() * delta
			if air_time > falling_time_threshold:
				falling = true
				air_time = 0
		if jumping and player.is_on_floor():
			jumping = false
		if player.is_on_floor() and landed:
			landed = false
		if player.is_on_floor() and falling:
			falling = false
			landed = true
		if player.is_on_floor():
			is_on_floor = true
		else:
			is_on_floor = false
		if not ability_controller.busy:
			if player.is_on_floor() and input.jump and player.use_stamina(jump_cost):
				player.velocity.y = jump_velocity
				jumping = true
		#if player.is_on_floor() and falling:
			#falling = false
	else:
		if not ability_controller.busy:
			if not dashing and player.use_stamina(dash_cost):
				dash_started = true
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
			player.velocity += player.get_gravity()
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

func add_movement_modifier(value: float, type: String = "weapon") -> void:
	var new_modifier: Dictionary = MOVEMENT_MODIFIER_DICT_PRESET.duplicate()
	new_modifier["amount"] = value
	new_modifier["type"] = type
	movement_modifiers.append(new_modifier)
	_update_movement_speed()

func remove_movement_modifier(value: float, type: String = "weapon") -> void:
	var new_modifier: Dictionary = MOVEMENT_MODIFIER_DICT_PRESET.duplicate()
	new_modifier["amount"] = value
	new_modifier["type"] = type
	if new_modifier in movement_modifiers:
		movement_modifiers.erase(new_modifier)
	_update_movement_speed()

func add_rotation_modifier(value: float, type: String = "weapon") -> void:
	var new_modifier: Dictionary = MOVEMENT_MODIFIER_DICT_PRESET.duplicate()
	new_modifier["amount"] = value
	new_modifier["type"] = type
	rotation_modifiers.append(new_modifier)
	_update_rotation_speed()

func remove_rotation_modifier(value: float, type: String = "weapon") -> void:
	var new_modifier: Dictionary = MOVEMENT_MODIFIER_DICT_PRESET.duplicate()
	new_modifier["amount"] = value
	new_modifier["type"] = type
	if new_modifier in rotation_modifiers:
		rotation_modifiers.erase(new_modifier)
	_update_rotation_speed()

func reset_weapon_modifiers() -> void:
	for modifier in movement_modifiers:
		if modifier["type"] == "weapon":
			movement_modifiers.erase(modifier)
	_update_movement_speed()
	
	for modifier in rotation_modifiers:
		if modifier["type"] == "weapon":
			rotation_modifiers.erase(modifier)
	_update_rotation_speed()

func _update_movement_speed() -> void:
	calculated_movement_modifiers = 1
	for modifier in movement_modifiers:
		calculated_movement_modifiers *= modifier["amount"]
	calculated_movement_speed = movement_speed * calculated_movement_modifiers

func _update_rotation_speed() -> void:
	calculated_rotation_modifiers = 1
	for modifier in rotation_modifiers:
		calculated_rotation_modifiers *= modifier["amount"]
	update_rotation_modifier.emit(calculated_rotation_modifiers)

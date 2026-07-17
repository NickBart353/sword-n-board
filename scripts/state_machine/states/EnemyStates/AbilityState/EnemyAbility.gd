@abstract class_name EnemyAbility extends EnemyState

@export var cool_down_timer: Timer
@export var attack_range: int = 0
@export var disable_me: bool = false
@export var look_at_player: bool = false
@export var normalize_ground_position: bool = false
@export var ground_raycast: RayCast3D

func Enter():
	super()
	if normalize_ground_position and ground_raycast:
		_set_correct_position()

func ready_to_use() -> bool:
	if disable_me:
		return false
	elif cool_down_timer:
		if not cool_down_timer.time_left and enemy.global_position.distance_to(player.global_position) < attack_range:
			return true
	elif enemy.global_position.distance_to(player.global_position) < attack_range:
		return true
	return false

func set_values(player_instance, enemy_instance, enemy_attack_range: int):
	player = player_instance
	enemy = enemy_instance
	if not attack_range:
		attack_range = enemy_attack_range

func _set_correct_position() -> void:
	if not ground_raycast.is_colliding():
		return
	var normal: Vector3 = ground_raycast.get_collision_normal()
	var new_basis: Basis = Basis()
	new_basis.y = normal
	new_basis.x = normal.cross(enemy.global_transform.basis.z).normalized()
	new_basis.z = new_basis.x.cross(normal).normalized()
	enemy.global_transform.basis = new_basis.orthonormalized()

func Physics_Update(_delta: float) -> void:
	if look_at_player:
		enemy.look_at(player.global_position)

@abstract class_name EnemyAbility extends EnemyState

@export var cool_down_timer: Timer
@export var attack_range: int = 0
@export var disable_me: bool = false

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

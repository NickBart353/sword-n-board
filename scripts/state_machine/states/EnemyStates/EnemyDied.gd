extends EnemyState

signal died

func Enter():
	super()
	$"../../Timers/DeathRemoveTimer".start()
	enemy.set_collision_mask_value(1, false)
	enemy.set_collision_layer_value(4, false)

func Exit():
	super()

func Physics_Update(_delta: float) -> void:
	enemy.velocity += enemy.get_gravity()

func _on_death_remove_timer_timeout() -> void:
	died.emit()

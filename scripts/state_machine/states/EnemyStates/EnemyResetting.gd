extends EnemyState

func Enter():
	super()
	$"../../Timers/ResettingTimer".start()
	enemy.set_collision_mask_value(1, false)

func Exit():
	super()
	enemy.velocity = Vector3.ZERO
	enemy.set_collision_mask_value(1, true)

func Physics_Update(delta: float) -> void:
	super(delta)
	enemy.velocity = Vector3(0,3,0)
	

func _on_resetting_timer_timeout() -> void:
	Transitioned.emit(self, "Follow")

extends EnemyState

func Enter():
	super()
	$"../../Timers/ResettingTimer".start()

func Exit():
	super()
	enemy.velocity = Vector3.ZERO

func Physics_Update(delta: float) -> void:
	super(delta)
	enemy.velocity = Vector3(0,3,0)

func _on_resetting_timer_timeout() -> void:
	Transitioned.emit(self, "Follow")

extends EnemyState

@onready var recovery_timer = $"../../Timers/RecoveryTimer"

func Enter():
	super()
	recovery_timer.start()

func Exit():
	super()

func Physics_Update(delta: float) -> void:
	super(delta)
	if not enemy.is_on_floor():
		enemy.velocity = enemy.get_gravity()

func _on_recovery_timer_timeout() -> void:
	Transitioned.emit(self, "Resetting")

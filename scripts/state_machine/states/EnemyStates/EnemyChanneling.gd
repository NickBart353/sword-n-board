extends EnemyState

@onready var charge_timer = $"../../Timers/ChargeTimer"

func Enter():
	super()
	charge_timer.start()

func Exit():
	super()

func Physics_Update(delta: float) -> void:
	super(delta)
	enemy.look_at(Vector3(player.global_position.x, player.global_position.y + 10, player.global_position.z), Vector3.UP, true)

func _on_charge_timer_timeout() -> void:
	Transitioned.emit(self, "Fire")

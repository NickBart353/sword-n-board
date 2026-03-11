extends EnemyState

@export var resetting_timer: Timer
@export var disable_collision_during_reset: bool = true

func Enter():
	super()
	resetting_timer.start()
	if disable_collision_during_reset:
		enemy.set_collision_mask_value(1, false)

func Exit():
	super()
	enemy.velocity = Vector3.ZERO
	if disable_collision_during_reset:
		enemy.set_collision_mask_value(1, true)

func Physics_Update(delta: float) -> void:
	super(delta)
	enemy.velocity = Vector3(0,3,0)

func _on_resetting_timer_timeout() -> void:
	Transitioned.emit(self, "Follow")

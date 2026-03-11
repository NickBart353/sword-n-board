extends EnemyState

@export var recovery_timer: Timer
@export var use_vfx: bool = true
@export var follow_up_state: Node

func Enter():
	super()
	recovery_timer.start()
	if use_vfx:
		VfxManager.create_stunned(Vector3(enemy.global_position.x, enemy.global_position.y + 3, enemy.global_position.z))

func Exit():
	super()

func Physics_Update(delta: float) -> void:
	super(delta)
	if not enemy.is_on_floor():
		enemy.velocity = enemy.get_gravity()

func _on_recovery_timer_timeout() -> void:
	Transitioned.emit(self, follow_up_state.name)

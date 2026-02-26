extends EnemyState
class_name EnemyChanneling

@export var charge_timer: Timer
@export var channeling_vfx_position: Node
@export var channeling_vfx: VfxManager.VFX
@export var follow_up_state: State

func Enter():
	super()
	charge_timer.timeout.connect(_on_charge_timer_timeout)
	charge_timer.start()
	var vfx_instance = VfxManager.create_vfx_from_enum(channeling_vfx, Vector3.ZERO, true).instantiate()
	enemy.add_child(vfx_instance)
	vfx_instance.global_position = channeling_vfx_position.global_position

func Exit():
	super()

func Physics_Update(delta: float) -> void:
	super(delta)
	enemy.look_at(Vector3(player.global_position.x, player.global_position.y + 10, player.global_position.z), Vector3.UP, true)

func _on_charge_timer_timeout() -> void:
	Transitioned.emit(self, follow_up_state.name)

extends EnemyAbility
class_name EnemyChanneling

@export var charge_timer: Timer
@export var channeling_vfx_position: Node
@export var channeling_vfx: VfxManager.VFX
@export var follow_up_state: State
@export var look_at_target: bool = true
@export var vfx_offset: Vector3  = Vector3.ZERO

var vfx_instance: Basic_VFX

func _ready() -> void:
	vfx_instance = VfxManager.create_vfx_from_enum(channeling_vfx, Vector3.ZERO, true).instantiate()
	enemy.add_child.call_deferred(vfx_instance)

func Enter():
	super()
	if not charge_timer.timeout.is_connected(_on_charge_timer_timeout):
		charge_timer.timeout.connect(_on_charge_timer_timeout)
	if vfx_instance and channeling_vfx_position:
		vfx_instance.global_position = channeling_vfx_position.global_position + vfx_offset
		vfx_instance.play()
	charge_timer.start()

func Exit():
	super()

func Physics_Update(delta: float) -> void:
	super(delta)
	if look_at_target:
		enemy.look_at(Vector3(player.global_position.x, player.global_position.y + 10, player.global_position.z), Vector3.UP, true)

func _on_charge_timer_timeout() -> void:
	Transitioned.emit(self, follow_up_state.name)

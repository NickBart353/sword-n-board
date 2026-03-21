extends EnemyAbility

@export var charge_timer: Timer
@export var pulling_back_speed: float = 0.1
@export var cutting_wind: Node
@export var tornado_vfx_container: Marker3D

var vfx_tornado_instance: Basic_VFX

func _ready() -> void:
	vfx_tornado_instance = VfxManager.create_vfx_from_enum(VfxManager.VFX.SMALL_TORNADO, Vector3.ZERO, true).instantiate()
	tornado_vfx_container.add_child.call_deferred(vfx_tornado_instance)

func Enter():
	super()
	charge_timer.start()
	cutting_wind.set_visible(true)
	vfx_tornado_instance.play()

func Exit():
	super()

func Physics_Update(delta: float) -> void:
	super(delta)
	enemy.look_at(player.global_position, Vector3.UP, true)
	enemy.rotate_object_local(Vector3.RIGHT, deg_to_rad(-30))
	var direction = player.global_position.direction_to(enemy.global_position)
	enemy.velocity = Vector3(direction.x, 5, direction.z) * pulling_back_speed

func _on_charge_timer_timeout() -> void:
	Transitioned.emit(self, "Dashing")

extends EnemyAbility

@export var charge_timer: Timer
@export var pulling_back_speed: float = 0.1
@export var cutting_wind: Node

func Enter():
	super()
	charge_timer.start()
	VfxManager.create_small_tornado(Vector3(enemy.global_position.x, enemy.global_position.y-4, enemy.global_position.z))
	cutting_wind.set_visible(true)

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

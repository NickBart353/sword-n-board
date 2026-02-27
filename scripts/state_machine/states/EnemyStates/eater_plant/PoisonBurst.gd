extends EnemyState

@export var bullet_position: Node
@export var cooldown_timer: Timer

var fired: bool = false
var target_location: Vector3

func Enter():
	super()
	fired = false
	target_location = Vector3(enemy.global_position.x, enemy.global_position.y + 20, enemy.global_position.z)
	enemy.ready_bombs(target_location)
	cooldown_timer.start()
	fired = true

func Exit():
	super()
	fired = false

func Physics_Update(delta: float) -> void:
	super(delta)
	if fired:
		Transitioned.emit(self, "Follow")

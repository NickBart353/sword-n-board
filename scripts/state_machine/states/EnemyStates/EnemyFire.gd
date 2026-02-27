extends EnemyState

@onready var bullet_position = $"../../BombPosition"

@export var cooldown: int = 30

var fired: bool = false
var target_location: Vector3

func Enter():
	super()
	fired = false
	target_location = player.global_position
	enemy.ready_bombs(target_location)
	$"../../Timers/PoisonTimer".start(cooldown)
	fired = true

func Exit():
	super()
	fired = false

func Physics_Update(delta: float) -> void:
	super(delta)
	if fired:
		Transitioned.emit(self, "Follow")

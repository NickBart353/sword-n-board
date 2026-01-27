extends EnemyState

@onready var bullet_position = $"../../BombPosition"

@export var cooldown: int = 30

var target_location: Vector3

func Enter():
	super()
	target_location = player.global_position
	enemy.ready_bombs(player.global_position)
	$"../../Timers/PoisonTimer".start(cooldown)

func Exit():
	super()

func Physics_Update(delta: float) -> void:
	super(delta)
	Transitioned.emit(self, "Follow")

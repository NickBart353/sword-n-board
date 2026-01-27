extends EnemyState

@onready var bullet_position = $"../../BulletPosition"

var target_location: Vector3

func Enter():
	super()
	target_location = player.global_position

func Exit():
	super()

func Physics_Update(delta: float) -> void:
	super(delta)
	

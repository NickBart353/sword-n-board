extends EnemyState

@export var return_speed: int = 10

var home_direction: Vector3

func Enter():
	super()
	home_direction = enemy.global_position.direction_to(enemy.origin_position)

func Exit():
	super()

func Physics_Update(delta: float) -> void:
	super(delta)
	home_direction = enemy.global_position.direction_to(enemy.origin_position)
	enemy.look_at(enemy.origin_position, Vector3.UP, true)
	enemy.velocity = home_direction * return_speed
	
	if enemy.global_position.distance_to(enemy.origin_position) < 2:
		Transitioned.emit(self, "Idle") 

extends EnemyState

@export var return_speed: int = 10
@export var disable_collision: bool = true

var home_direction: Vector3

func Enter():
	super()
	home_direction = enemy.global_position.direction_to(enemy.origin_position)
	if disable_collision:
		#enemy.monitoring = false
		#enemy.monitorable = false
		enemy.set_collision_mask_value(1, false)
		enemy.set_collision_layer_value(6, false)
		enemy.set_collision_layer_value(3, false)

func Exit():
	super()
	if disable_collision:
		#enemy.monitoring = true
		#enemy.monitorable = true
		enemy.set_collision_mask_value(1, true)
		enemy.set_collision_layer_value(6, true)
		enemy.set_collision_layer_value(3, true)
	enemy.look_at(enemy.origin_position, Vector3.UP, true)

func Physics_Update(delta: float) -> void:
	super(delta)
	home_direction = enemy.global_position.direction_to(enemy.origin_position)
	enemy.velocity = home_direction * return_speed
	
	if enemy.global_position.distance_squared_to(enemy.origin_position) < 5:
		Transitioned.emit(self, "Idle") 

extends EnemyState

@export var wander_speed: int = 10
@export var allowed_distance_to_origin: int = 20
@export var aggro_range: int = 20

var wander_time = 0
var wander_direction: Vector3
var distance

func randomize_wander():
	if enemy.global_position.distance_to(enemy.origin_position) > allowed_distance_to_origin:
		Transitioned.emit(self, "Return")
		return
	
	wander_time = randi_range(4, 7)
	wander_direction = Vector3(randf_range(-1,1), 0, randf_range(-1,1))
	wander_direction.normalized()

func Enter():
	super()
	randomize_wander()

func Exit():
	super()

func Update(delta: float) -> void:
	super(delta)
	if wander_time > 0:
		wander_time -= delta
	else:
		randomize_wander()

func Physics_Update(delta: float) -> void:
	super(delta)
	if not enemy.global_transform.origin.is_equal_approx(enemy.global_position + wander_direction):
		enemy.look_at(enemy.global_position + wander_direction, Vector3.UP, true)
	
	enemy.velocity = wander_direction * wander_speed
	
	distance = player.global_position - enemy.global_position
	if distance.length() < aggro_range:
		Transitioned.emit(self, "Follow")

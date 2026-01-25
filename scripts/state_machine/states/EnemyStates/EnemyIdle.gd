extends EnemyState

@export var enemy: CharacterBody3D
@export var wander_speed: int = 10

var wander_time
var wander_direction: Vector3
var distance

func randomize_wander():
	wander_time = randi_range(1, 5)
	wander_direction = Vector3(randf_range(-0.5,0.5), 0, randf_range(-0.5,0.5))

func Enter():
	super()
	randomize_wander()

func Exit():
	enemy.velocity = Vector3.ZERO

func Update(delta: float) -> void:
	if wander_time > 0:
		wander_time -= delta
	else:
		randomize_wander()

func Physics_Update(_delta: float) -> void:
	distance = player.global_position - enemy.global_position
	
	if enemy:
		enemy.velocity = wander_direction * wander_speed
	if distance.length() < 10:
		Transitioned.emit(self, "Follow")

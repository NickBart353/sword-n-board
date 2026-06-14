extends EnemyState

@export var wander_speed: int = 10
@export var allowed_distance_to_origin: int = 20
@export var aggro_range: int = 20

signal reset_health

var wander_time: float = 0.0
var wander_direction: Vector3
var distance: Vector3
var called: bool = false

func randomize_wander():
	wander_time = randi_range(4, 7)
	wander_direction = Vector3(randf_range(-1,1), 0, randf_range(-1,1))
	wander_direction.normalized()

func Enter():
	super()
	#print("in combat: ", CombatManager.is_in_combat(), "; count: ", CombatManager.combat_units, "; state: ", name)
	randomize_wander()
	called = false
	reset_health.emit()

func Exit():
	super()
	called = false
	distance = Vector3.ZERO

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
	if enemy.global_position.distance_to(enemy.origin_position) > allowed_distance_to_origin:
		Transitioned.emit(self, "Return")
		return
	if distance.length() < aggro_range or called:
		Transitioned.emit(self, "Engage")
		return

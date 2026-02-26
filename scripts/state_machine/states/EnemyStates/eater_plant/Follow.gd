extends EnemyState

@export var follow_speed: int = 1
@export var attack_range: int = -1
@export var follow_range: int = 50

func Enter():
	super()

func Exit():
	super()

func Physics_Update(delta: float) -> void:
	super(delta)
	enemy.look_at(player.global_position, Vector3.UP, true)
	
	var distance = player.global_position - enemy.global_position
	
	enemy.velocity = enemy.global_position.direction_to(player.global_position) * follow_speed
	
	if distance.length() > follow_range:
		Transitioned.emit(self, "Idle")
		return
	if (distance.length() < attack_range and not $"../../Timers/PoisonTimer".time_left):
		Transitioned.emit(self, "Channeling")
		return
	if distance.length() < attack_range:
		Transitioned.emit(self, "Locked")
		return

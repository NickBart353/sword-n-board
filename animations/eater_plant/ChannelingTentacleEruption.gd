extends EnemyState

@export_range(0.0, 1.0) var wind_up_speed: float = 0.5
var root_counter_top: int
var root_counter: int

func Enter():
	super()
	root_counter_top = enemy.tentacle_root_container.get_children().size()
	root_counter = 0
	for tentacle_root in enemy.tentacle_root_container.get_children():
		tentacle_root.wind_up(wind_up_speed)
		if not tentacle_root.winded_up.is_connected(_finished_wind_up):
			tentacle_root.winded_up.connect(_finished_wind_up)

func Exit():
	super()

func Physics_Update(delta: float) -> void:
	super(delta)

func _finished_wind_up():
	root_counter += 1
	if root_counter == root_counter_top:
		Transitioned.emit(self, "TentacleSlam")

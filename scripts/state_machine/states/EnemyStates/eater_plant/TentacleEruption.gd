extends EnemyState

@export var eruption_cooldown: Timer
var is_erupted: bool

func Enter():
	super()
	is_erupted = false
	enemy.ready_tentacles()
	eruption_cooldown.start()
	is_erupted = true

func Exit():
	super()

func Physics_Update(delta: float) -> void:
	super(delta)
	if is_erupted:
		finished_erupting()

func finished_erupting():
	Transitioned.emit(self, "Follow")

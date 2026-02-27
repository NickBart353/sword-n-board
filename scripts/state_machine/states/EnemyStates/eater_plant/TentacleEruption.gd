extends EnemyState

var erupted: bool

func Enter():
	super()
	erupted = false
	enemy.erupt_tentacles()

func Exit():
	super()

func Physics_Update(delta: float) -> void:
	super(delta)

func finished_erupting():
	Transitioned.emit(self, "Follow")

extends EnemyDied

signal remove_spikes

func Enter():
	super()
	remove_spikes.emit()
	for tentacle in enemy.tentacle_root_container.get_children():
		tentacle.die()

extends EnemyDied

func Enter():
	super()
	
	for tentacle in enemy.tentacle_root_container.get_children():
		tentacle.die()

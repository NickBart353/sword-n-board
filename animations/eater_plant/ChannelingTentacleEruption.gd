extends EnemyChanneling

func Enter():
	player = get_tree().get_first_node_in_group("Player")
	anim_tree.travel("Channel")

func Exit():
	super()

func Physics_Update(delta: float) -> void:
	super(delta)

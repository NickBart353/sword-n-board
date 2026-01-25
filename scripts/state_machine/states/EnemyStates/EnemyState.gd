extends State
class_name EnemyState

var player

func Enter():
	super()
	player = get_tree().get_first_node_in_group("Player")

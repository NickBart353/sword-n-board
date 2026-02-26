extends EnemyState

@export var bullet_position: Node
@export var cooldown_timer: Timer

var fired: bool = false
var target_location: Vector3

func Enter():
	player = get_tree().get_first_node_in_group("Player")
	anim_tree.travel("Attack")
	fired = false
	target_location = player.global_position
	enemy.ready_bombs(Vector3(enemy.global_position.x, enemy.global_position.y + 10, enemy.global_position.z))
	cooldown_timer.start()
	fired = true

func Exit():
	super()
	fired = false

func Physics_Update(delta: float) -> void:
	super(delta)
	if fired:
		Transitioned.emit(self, "Follow")

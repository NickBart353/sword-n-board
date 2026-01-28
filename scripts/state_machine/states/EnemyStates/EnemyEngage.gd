extends EnemyState

@export var pull_distance: int = 10

func Enter():
	super()
	$"../../Timers/EngageTimer".start()
	var vfx_instance = VfxManager.create_sound_waves(Vector3.ZERO, true).instantiate()
	$"../../BombPosition".add_child(vfx_instance)
	for called_enemy in get_tree().get_nodes_in_group("Enemy"):
		if enemy.global_position.distance_to(called_enemy.global_position) < pull_distance:
			called_enemy.force_engage()

func Exit():
	super()

func Update(delta: float) -> void:
	super(delta)

func Physics_Update(delta: float) -> void:
	super(delta)
	enemy.look_at(player.global_position, Vector3.UP, true)

func _on_engage_timer_timeout() -> void:
	Transitioned.emit(self, "Follow")

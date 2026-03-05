extends EnemyState

signal died

func Enter():
	super()
	$"../../Timers/DeathRemoveTimer".start()
	enemy.set_collision_layer_value(4, false)
	anim_tree.tree_root = anim_tree.tree_root.duplicate(true)
	anim_tree.set("parameters/Dissolve/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func Exit():
	super()

func Physics_Update(_delta: float) -> void:
	enemy.velocity += enemy.get_gravity()

func _on_death_remove_timer_timeout() -> void:
	died.emit()

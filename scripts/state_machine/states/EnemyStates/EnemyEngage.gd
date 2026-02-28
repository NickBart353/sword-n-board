extends EnemyState

@export var pull_distance: int = 10
@export var time_till_engaged: int = 3
@export var yell_vfx_position: Node
@export var look_at_enemy: bool = true
@export var only_look_horizontally: bool = false

func Enter():
	super()
	var engage_timer: Timer = Timer.new()
	add_child(engage_timer, true)
	engage_timer.timeout.connect(_on_engage_timer_timeout)
	engage_timer.start(time_till_engaged)
	var vfx_instance = VfxManager.create_sound_waves(Vector3.ZERO, true).instantiate()
	yell_vfx_position.add_child(vfx_instance)
	for called_enemy in get_tree().get_nodes_in_group("Enemy"):
		if enemy.global_position.distance_to(called_enemy.global_position) < (pull_distance * 2):
			called_enemy.force_engage()

func Exit():
	super()

func Update(delta: float) -> void:
	super(delta)

func Physics_Update(delta: float) -> void:
	super(delta)
	if look_at_enemy:
		enemy.look_at(player.global_position, Vector3.UP, true)
	if only_look_horizontally:
		enemy.rotate_y(0.0)

func _on_engage_timer_timeout() -> void:
	get_child(0).queue_free()
	Transitioned.emit(self, "Follow")

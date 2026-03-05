extends EnemyState

var root_counter_top: int 
var root_counter: int
var rotation: float
var current_rotation: float
var slam_counter: int
@export var slam_amount: int = 3
@export_range(0.0, 100.0) var rotation_speed: float = 5

func Enter():
	super()
	slam_counter = 0
	root_counter = 0
	root_counter_top = enemy.tentacle_root_container.get_children().size() 
	for tentacle_root in enemy.tentacle_root_container.get_children():
		if not tentacle_root.slammed.is_connected(_finished_slam):
			tentacle_root.slammed.connect(_finished_slam)
		if not tentacle_root.winding.is_connected(_winding_slam):
			tentacle_root.winding.connect(_winding_slam)
		tentacle_root.wind_up()
	rotation = randf_range(-45.0, 45.0)
	var tween = create_tween()
	tween.tween_property(enemy.tentacle_root_container, "rotation:y", deg_to_rad(rotation), 4)

func Exit():
	super()

func Physics_Update(delta: float) -> void:
	super(delta)

func _finished_slam():
	root_counter += 1
	if root_counter == root_counter_top:
		slam_counter += 1
		root_counter = 0
		if slam_counter == slam_amount:
			for tentacle_root in enemy.tentacle_root_container.get_children():
				tentacle_root.idle()
			Transitioned.emit(self, "Follow")
		else:
			for tentacle_root in enemy.tentacle_root_container.get_children():
				tentacle_root.re_wind()

func _winding_slam():
	var tween = create_tween()
	rotation = randf_range(-45.0, 45.0)
	tween.tween_property(enemy.tentacle_root_container, "rotation:y", deg_to_rad(rotation), 2)

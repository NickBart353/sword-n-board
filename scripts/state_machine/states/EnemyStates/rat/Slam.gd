extends EnemyAbility

@export var slam_Scene: PackedScene
@export var slam_position: Node
@export var damage: int = 25

var slam_instance: Area3D

func Enter():
	super()
	slam_instance = slam_Scene.instantiate()
	add_child(slam_instance)
	slam_instance.global_position = slam_position.global_position
	slam_instance.slam_finished.connect(_slam_finished)

func slam():
	if slam_instance:
		slam_instance.play_slam(damage)

func _slam_finished(_slam: Area3D):
	_slam.queue_free()
	cool_down_timer.start()
	Transitioned.emit(self, "Follow")

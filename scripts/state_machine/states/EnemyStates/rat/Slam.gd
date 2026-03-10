extends EnemyAbility

@export var slam_Scene: PackedScene
@export var slam_position: Node
@export var damage: int = 25

func Enter():
	super()
	var slam_instance: Area3D = slam_Scene.instantiate()
	add_child(slam_instance)
	slam_instance.slam_finished.connect(_slam_finished)
	slam_instance.play_slam(damage)

func _slam_finished(slam: Area3D):
	slam.queue_free()
	cool_down_timer.start()
	Transitioned.emit(self, "Follow")

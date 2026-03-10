extends EnemyAbility

@export var claw_scene: PackedScene
@export var claw_position: Node
@export var damage: int = 25

func Enter():
	super()
	var claw_instance: Area3D = claw_scene.instantiate()
	add_child(claw_instance)
	claw_instance.claw_finished.connect(_claw_finished)
	claw_instance.play_claw(claw_position.global_transform, damage)

func _claw_finished(claw: Area3D):
	claw.queue_free()
	cool_down_timer.start()
	Transitioned.emit(self, "Follow")
	

extends EnemyAbility

@export var bite_scene: PackedScene
@export var bite_position: Node
@export var damage: int = 25

func Enter():
	super()
	var bite_instance: Area3D = bite_scene.instantiate()
	add_child(bite_instance)
	bite_instance.bite_finished.connect(_bite_finished)
	bite_instance.play_bite(bite_position.global_transform, damage)

func _bite_finished(bite: Area3D):
	bite.queue_free()
	cool_down_timer.start()
	Transitioned.emit(self, "Follow")
	

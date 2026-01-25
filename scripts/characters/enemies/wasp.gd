extends Enemy

func _physics_process(_delta: float) -> void:
	move_and_slide()

func take_damage(damage_dealt, body):
	pass

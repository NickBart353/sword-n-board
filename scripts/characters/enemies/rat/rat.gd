class_name Rat extends Enemy

func _physics_process(_delta: float) -> void:
	velocity += get_gravity()
	move_and_slide()

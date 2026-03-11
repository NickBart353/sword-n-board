class_name Rat extends Enemy

func _physics_process(_delta: float) -> void:
	velocity += get_gravity()
	move_and_slide()


func _on_recovery_timer_timeout() -> void:
	pass # Replace with function body.

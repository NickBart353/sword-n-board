class_name Torch extends ItemEntity

signal hit

func _on_body_entered(body: Node3D) -> void:
	if body is Enemy:
		hit.emit(body, data.damage)

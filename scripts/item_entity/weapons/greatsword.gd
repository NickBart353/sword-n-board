extends MeleeWeapon

signal hit

func _on_body_entered(body: Node3D) -> void:
	if body is Enemy:
		hit.emit(body, data.normal_damage)
		#sword_player.play()

func _set_marker_values():
	pass

extends MeleeWeapon

signal hit

func _on_body_entered(body: Node3D) -> void:
	if body is Enemy:
		hit.emit(body, data.normal_damage)

func _set_marker_values():
	marker_positions = {
		"Hand": {
			"L_Position": Vector3(-0.035, 0.023, 0.111),
			"R_Position": Vector3(0.035, 0.023, 0.111),
			"L_Rotation": Vector3(-67.5, -90.0, 90.0),
			"R_Rotation": Vector3(67.5, -90.0, 90.0),
			},
		"Finger": {
			"L_Position": Vector3(0.029, -0.002, -0.043),
			"R_Position": Vector3(-0.029, -0.002, -0.043),
			"L_Rotation": Vector3(-67.5, -90.0, 90.0),
			"R_Rotation": Vector3(67.5, -90.0, 90.0),
			},
		"Thumb": {
			"L_Position": Vector3(0.038, 0.041, -0.032),
			"R_Position": Vector3(-0.038, 0.041, -0.032),
			"L_Rotation": Vector3.ZERO,
			"R_Rotation": Vector3.ZERO,
			},
		"FingerPole": {
			"L_Position": Vector3(-0.98, 0, -1.206),
			"R_Position": Vector3(0.98, 0.0, -1.206),
			"L_Rotation": Vector3.ZERO,
			"R_Rotation": Vector3.ZERO,
			},
		"ThumbPole": {
			"L_Position": Vector3(0.251, 0.206, 0.316),
			"R_Position": Vector3(-0.251, 0.206, 0.316),
			"L_Rotation": Vector3.ZERO,
			"R_Rotation": Vector3.ZERO,
			},
	}

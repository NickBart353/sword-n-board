extends MeleeWeapon

signal hit

func _on_body_entered(body: Node3D) -> void:
	if body is Enemy:
		hit.emit(body, data.normal_damage)

func _set_marker_values():
	marker_positions = {
		"Hand": {
			"L_Position": Vector3(0.035, 0.002, 0.167),
			"R_Position": Vector3(0.035, 0.002, 0.155),
			"L_Rotation": Vector3(-67.5, -90.0, 90.0),
			"R_Rotation": Vector3(67.5, -90.0, 90.0),
			},
		"Finger": {
			"L_Position": Vector3(-0.024, 0, -0.028),
			"R_Position": Vector3(-0.044, -0.006, -0.047),
			#"L_Position": Vector3(0.044, 0.002, 0.15),
			#"R_Position": Vector3(-0.044, 0.002, 0.15),
			"L_Rotation": Vector3(-67.5, -90.0, 90.0),
			"R_Rotation": Vector3(67.5, -90.0, 90.0),
			#"L_Rotation": Vector3.ZERO,
			#"R_Rotation": Vector3.ZERO,
			},
		"Thumb": {
			"L_Position": Vector3(0.013, 0.024, -0.026),
			"R_Position": Vector3(-0.024, 0.024, 0),
			"L_Rotation": Vector3.ZERO,
			"R_Rotation": Vector3.ZERO,
			},
		"FingerPole": {
			"L_Position": Vector3(-0.13, -0.097, -0.07),
			"R_Position": Vector3(0.225, 0.012, -0.252),
			"L_Rotation": Vector3.ZERO,
			"R_Rotation": Vector3.ZERO,
			},
		"ThumbPole": {
			"L_Position": Vector3(0.111, -0.015, -0.078),
			"R_Position": Vector3(-0.149, 0.044, 0.01),
			"L_Rotation": Vector3.ZERO,
			"R_Rotation": Vector3.ZERO,
			},
	}

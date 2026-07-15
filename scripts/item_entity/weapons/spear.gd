extends MeleeWeapon

signal hit

func _on_body_entered(body: Node3D) -> void:
	if body is Enemy:
		hit.emit(body, data.normal_damage)
		play_blood_vfx()

func _set_marker_values():
	marker_positions = {
		"Hand": {
			"L_Position": Vector3(0.035, 0.002, 0.15),
			"R_Position": Vector3(0.032, -0.05, 0.133),
			"L_Rotation": Vector3(-67.5, -90.0, 90.0),
			"R_Rotation": Vector3(67.5, -90.0, 90.0),
			},
		"Finger": {
			"L_Position": Vector3(-0.034, 0.002, -0.031),
			"R_Position": Vector3(0.022, -0.039, -0.052),
			#"L_Position": Vector3(0.044, 0.002, 0.15),
			#"R_Position": Vector3(-0.044, 0.002, 0.15),
			"L_Rotation": Vector3(-67.5, -90.0, 90.0),
			"R_Rotation": Vector3(67.5, -90.0, 90.0),
			#"L_Rotation": Vector3.ZERO,
			#"R_Rotation": Vector3.ZERO,
			},
		"Thumb": {
			"L_Position": Vector3(0.032, 0.043, -0.005),
			"R_Position": Vector3(-0.033, 0.025, 0.006),
			"L_Rotation": Vector3.ZERO,
			"R_Rotation": Vector3.ZERO,
			},
		"FingerPole": {
			"L_Position": Vector3(-0.163, -0.007, 0.084),
			"R_Position": Vector3(0.062, -0.027, -0.11),
			"L_Rotation": Vector3.ZERO,
			"R_Rotation": Vector3.ZERO,
			},
		"ThumbPole": {
			"L_Position": Vector3(0.105, 0.07, 0.021),
			"R_Position": Vector3(-0.176, 0.11, -0.017),
			"L_Rotation": Vector3.ZERO,
			"R_Rotation": Vector3.ZERO,
			},
	}

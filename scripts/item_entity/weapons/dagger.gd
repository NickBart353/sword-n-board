class_name Dagger extends MeleeWeapon

func _on_body_entered(body: Node3D) -> void:
	hit_body(body)

func _set_marker_values():
	marker_positions = {
		"Hand": {
			"L_Position": Vector3(0.018, 0.014, 0.151),
			"R_Position": Vector3(0.051, 0.004, 0.127),
			"L_Rotation": Vector3(-67.5, -90.0, 90.0),
			"R_Rotation": Vector3(67.5, -90.0, 90.0),
			},
		"Finger": {
			"L_Position": Vector3(-0.013, 0.021, -0.035),
			"R_Position": Vector3(-0.008, 0.017, -0.047),
			#"L_Position": Vector3(0.044, 0.002, 0.15),
			#"R_Position": Vector3(-0.044, 0.002, 0.15),
			"L_Rotation": Vector3(-67.5, -90.0, 90.0),
			"R_Rotation": Vector3(67.5, -90.0, 90.0),
			#"L_Rotation": Vector3.ZERO,
			#"R_Rotation": Vector3.ZERO,
			},
		"Thumb": {
			"L_Position": Vector3(0.014, 0.066, -0.008),
			"R_Position": Vector3(-0.003, 0.063, -0.008),
			"L_Rotation": Vector3.ZERO,
			"R_Rotation": Vector3.ZERO,
			},
		"FingerPole": {
			"L_Position": Vector3(-0.333, -0.032, -0.164),
			"R_Position": Vector3(0.183, -0.029, -0.13),
			"L_Rotation": Vector3.ZERO,
			"R_Rotation": Vector3.ZERO,
			},
		"ThumbPole": {
			"L_Position": Vector3(0.214, 0.139, -0.091),
			"R_Position": Vector3(-0.189, 0.045, 0.109),
			"L_Rotation": Vector3.ZERO,
			"R_Rotation": Vector3.ZERO,
			},
	}

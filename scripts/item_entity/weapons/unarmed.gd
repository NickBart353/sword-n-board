extends MeleeWeapon

signal hit

func _on_body_entered(body: Node3D) -> void:
	if body is Enemy:
		hit.emit(body, data.normal_damage)
		play_blood_vfx()

func _set_marker_values():
	marker_positions = {
		"Hand": {
			#"L_Position": Vector3(-0.035, 0.023, 0.111),
			#"L_Position": Vector3(0.042,  -0.017, 0.11
			#"L_Position": Vector3(0.035, 0.023, 0.111),
			#"L_Position": Vector3(0.035, 0.023, 0.111),
			"L_Position": Vector3(0.035, 0.023, 0.111),
			"R_Position": Vector3(0.035, 0.023, 0.111),
			"L_Rotation": Vector3.ZERO,#(67.5, -90.0, 90.0),
			"R_Rotation": Vector3.ZERO,#(-67.5, -90.0, 90.0),
			},
		"Finger": {
			#"L_Position": Vector3(0.029, -0.002, -0.043),
			#"L_Position": Vector3(-0.086, 0.002,  0.01),
			#"L_Position": Vector3(-0.029, -0.002, -0.043),
			#"L_Position": Vector3(-0.062, -0.028, -0.018),
			"L_Position": Vector3(-0.1, -0.024, 0.01),
			"R_Position": Vector3(-0.029, -0.002, -0.043),
			"L_Rotation": Vector3.ZERO,#(67.5, -90.0, 90.0),
			"R_Rotation": Vector3.ZERO,#(-67.5, -90.0, 90.0),
			},
		"Thumb": {
			#"L_Position": Vector3(0.038, 0.041, -0.032),
			#"L_Position": Vector3(-0.074, -0.038, 0.0),
			#"L_Position": Vector3(-0.038, 0.041, -0.032),
			#"L_Position": Vector3(-0.023, -0.013, -0.007),
			"L_Position": Vector3(-0.09, -0.03, 0.004),
			"R_Position": Vector3(-0.038, 0.041, -0.032),
			"L_Rotation": Vector3.ZERO,
			"R_Rotation": Vector3.ZERO,
			},
		"FingerPole": {
			#"L_Position": Vector3(-0.98, 0, -1.206),
			#"L_Position": Vector3(0.98, 0, -1.206),
			#"L_Position": Vector3(0.98, 0.0, -1.206),
			#"L_Position": Vector3(-0.174, 0.358, -0.166),
			"L_Position": Vector3(-0.099, 0.186, -0.22),
			"R_Position": Vector3(0.98, 0.0, -1.206),
			"L_Rotation": Vector3.ZERO,
			"R_Rotation": Vector3.ZERO,
			},
		"ThumbPole": {
			#"L_Position": Vector3(0.251, 0.206, 0.316),
			#"L_Position": Vector3(0.186, -1.07, -0.085),
			#"L_Position": Vector3(-0.251, 0.206, 0.316),
			#"L_Position": Vector3(0.144, 0.069, -0.086),
			"L_Position": Vector3( -0.077, -0.126, -0.075),
			"R_Position": Vector3(-0.251, 0.206, 0.316),
			"L_Rotation": Vector3.ZERO,
			"R_Rotation": Vector3.ZERO,
			},
	}

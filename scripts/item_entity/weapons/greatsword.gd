extends MeleeWeapon

signal hit

func _on_body_entered(body: Node3D) -> void:
	if body is Enemy:
		hit.emit(body, data.normal_damage)
		#sword_player.play()

func _set_marker_values():
	marker_positions = {
		"Hand": {
			"L_Position": Vector3(-0.049, -1.033, 0.1),
			"R_Position": Vector3(0.155, -0.851, 0.117),
			"L_Rotation": Vector3(-67.5, -90.0, 90.0),
			"R_Rotation": Vector3(67.5, -90.0, 90.0),
			},
		"Finger": {
			"L_Position": Vector3(0.021, -1.003, -0.053),
			"R_Position": Vector3(-0.009, -0.828, -0.128),
			#"L_Position": Vector3(0.044, 0.002, 0.15),
			#"R_Position": Vector3(-0.044, 0.002, 0.15),
			"L_Rotation": Vector3(-67.5, -90.0, 90.0),
			"R_Rotation": Vector3(67.5, -90.0, 90.0),
			#"L_Rotation": Vector3.ZERO,
			#"R_Rotation": Vector3.ZERO,
			},
		"Thumb": {
			"L_Position": Vector3(0.041, -0.989, 0.025),
			"R_Position": Vector3(-0.001, -0.814, 0.056),
			"L_Rotation": Vector3.ZERO,
			"R_Rotation": Vector3.ZERO,
			},
		"FingerPole": {
			"L_Position": Vector3(-0.06, -0.971, -0.172),
			"R_Position": Vector3(-0.034, -0.957, -0.191),
			"L_Rotation": Vector3.ZERO,
			"R_Rotation": Vector3.ZERO,
			},
		"ThumbPole": {
			"L_Position": Vector3(0.071, -0.919, 0.021),
			"R_Position": Vector3(-0.251, 0.206, 0.316),
			"L_Rotation": Vector3.ZERO,
			"R_Rotation": Vector3.ZERO,
			},
	}

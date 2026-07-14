extends MeleeWeapon

signal hit

func _on_body_entered(body: Node3D) -> void:
	if body is Enemy:
		hit.emit(body, data.normal_damage)
		play_blood_vfx()

func _set_marker_values():
	marker_positions = {
		"Hand": {
			"L_Position": Vector3(-0.159, 0.025, 0.013),
			"R_Position": Vector3(0.167, 0.252, 0.022),
			"L_Rotation": Vector3(-67.5, -90.0, 90.0),
			"R_Rotation": Vector3(67.5, -90.0, 90.0),
			},
		"Finger": {
			"L_Position": Vector3(0.03, 0.008, -0.067),
			"R_Position": Vector3(-0.044, 0.245, -0.07),
			#"L_Position": Vector3(0.044, 0.002, 0.15),
			#"R_Position": Vector3(-0.044, 0.002, 0.15),
			"L_Rotation": Vector3(-67.5, -90.0, 90.0),
			"R_Rotation": Vector3(67.5, -90.0, 90.0),
			#"L_Rotation": Vector3.ZERO,
			#"R_Rotation": Vector3.ZERO,
			},
		"Thumb": {
			"L_Position": Vector3(0.013, 0.052, 0.018),
			"R_Position": Vector3(-0.061, 0.262, 0.042),
			"L_Rotation": Vector3.ZERO,
			"R_Rotation": Vector3.ZERO,
			},
		"FingerPole": {
			"L_Position": Vector3(-0.114, -0.099, -0.223),
			"R_Position": Vector3(-0.085, -0.159, -0.361),
			"L_Rotation": Vector3.ZERO,
			"R_Rotation": Vector3.ZERO,
			},
		"ThumbPole": {
			"L_Position": Vector3(-0.009, 0.157, 0.105),
			"R_Position": Vector3(-0.063, 0.207, 0.139),
			"L_Rotation": Vector3.ZERO,
			"R_Rotation": Vector3.ZERO,
			},
	}

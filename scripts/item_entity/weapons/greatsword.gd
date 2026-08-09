extends MeleeWeapon

@export var impact_location: Marker3D

func _on_body_entered(body: Node3D) -> void:
	hit_body(body)

func _set_marker_values():
	marker_positions = {
		"Hand": {
			"L_Position": Vector3(-0.092, -0.042, 0.066),
			"R_Position": Vector3(0.083, 0.082, 0.083),
			"L_Rotation": Vector3(-67.5, -90.0, 90.0),
			"R_Rotation": Vector3(67.5, -90.0, 90.0),
			},
		"Finger": {
			"L_Position": Vector3(0.052, -0.111, -0.044),
			"R_Position": Vector3(-0.047, 0.055, -0.034),
			#"L_Position": Vector3(0.044, 0.002, 0.15),
			#"R_Position": Vector3(-0.044, 0.002, 0.15),
			"L_Rotation": Vector3(-67.5, -90.0, 90.0),
			"R_Rotation": Vector3(67.5, -90.0, 90.0),
			#"L_Rotation": Vector3.ZERO,
			#"R_Rotation": Vector3.ZERO,
			},
		"Thumb": {
			"L_Position": Vector3(0.045, -0.048, 0.008),
			"R_Position": Vector3(-0.024, 0.029, -0.008),
			"L_Rotation": Vector3.ZERO,
			"R_Rotation": Vector3.ZERO,
			},
		"FingerPole": {
			"L_Position": Vector3(-0.081, -0.143, -0.111),
			"R_Position": Vector3(-0.025,-0.097, -0.207),
			"L_Rotation": Vector3.ZERO,
			"R_Rotation": Vector3.ZERO,
			},
		"ThumbPole": {
			"L_Position": Vector3(0.014, -0.07, 0.135),
			"R_Position": Vector3(-0.1, 0.105, 0.05),
			"L_Rotation": Vector3.ZERO,
			"R_Rotation": Vector3.ZERO,
			},
	}

extends MeleeWeapon

@export var impact_location: Marker3D

func _on_body_entered(body: Node3D) -> void:
	hit_body(body)

func _set_marker_values():
	marker_positions = {
		"Hand": {
			"L_Position": Vector3(-0.17, -0.045, 0.03),
			"R_Position": Vector3(0.108, 0.093, 0.153),
			"L_Rotation": Vector3(-67.5, -90.0, 90.0),
			"R_Rotation": Vector3(67.5, -90.0, 90.0),
			},
		"Finger": {
			"L_Position": Vector3(0.017, -0.068, -0.019),
			"R_Position": Vector3(-0.007, 0.133, -0.029),
			#"L_Position": Vector3(0.044, 0.002, 0.15),
			#"R_Position": Vector3(-0.044, 0.002, 0.15),
			"L_Rotation": Vector3(-67.5, -90.0, 90.0),
			"R_Rotation": Vector3(67.5, -90.0, 90.0),
			#"L_Rotation": Vector3.ZERO,
			#"R_Rotation": Vector3.ZERO,
			},
		"Thumb": {
			"L_Position": Vector3(0.058, 0.024, 0.054),
			"R_Position": Vector3(-0.027, 0.128, 0.049),
			"L_Rotation": Vector3.ZERO,
			"R_Rotation": Vector3.ZERO,
			},
		"FingerPole": {
			"L_Position": Vector3(-0.035, 0, -0.161),
			"R_Position": Vector3(0.074, 0.128, -0.096),
			"L_Rotation": Vector3.ZERO,
			"R_Rotation": Vector3.ZERO,
			},
		"ThumbPole": {
			"L_Position": Vector3(-0.071, 0.01, 0.11),
			"R_Position": Vector3(-0.092, 0.13, 0.078),
			"L_Rotation": Vector3.ZERO,
			"R_Rotation": Vector3.ZERO,
			},
	}

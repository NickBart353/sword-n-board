extends MeleeWeapon

@export var audio_player: AudioStreamPlayer3D
@export var impact_location: Marker3D

func _on_body_entered(body: Node3D) -> void:
	hit_body(body)

func _set_marker_values():
	marker_positions = {
		"Hand": {
			"L_Position": Vector3(-0.167, 0.053, -0.045),
			"R_Position": Vector3(0.159, 0.178, 0.026),
			"L_Rotation": Vector3(-67.5, -90.0, 90.0),
			"R_Rotation": Vector3(67.5, -90.0, 90.0),
			},
		"Finger": {
			"L_Position": Vector3(0.037, -0.101, -0.025),
			"R_Position": Vector3(-0.018, 0.106, -0.065),
			#"L_Position": Vector3(0.044, 0.002, 0.15),
			#"R_Position": Vector3(-0.044, 0.002, 0.15),
			"L_Rotation": Vector3(-67.5, -90.0, 90.0),
			"R_Rotation": Vector3(67.5, -90.0, 90.0),
			#"L_Rotation": Vector3.ZERO,
			#"R_Rotation": Vector3.ZERO,
			},
		"Thumb": {
			"L_Position": Vector3(0.047, -0.033, 0.01),
			"R_Position": Vector3(-0.087, 0.118, 0.03),
			"L_Rotation": Vector3.ZERO,
			"R_Rotation": Vector3.ZERO,
			},
		"FingerPole": {
			"L_Position": Vector3(-0.129, -0.285, -0.286),
			"R_Position": Vector3(-0.088, 0.042, -0.208),
			"L_Rotation": Vector3.ZERO,
			"R_Rotation": Vector3.ZERO,
			},
		"ThumbPole": {
			"L_Position": Vector3(0.104, -0.066, 0.13),
			"R_Position": Vector3(-0.077, 0.22, 0.059),
			"L_Rotation": Vector3.ZERO,
			"R_Rotation": Vector3.ZERO,
			},
	}

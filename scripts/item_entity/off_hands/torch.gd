class_name Torch extends MeleeWeapon

@export var sword_player: AudioStreamPlayer3D

signal hit

func _on_body_entered(body: Node3D) -> void:
	if body is Enemy:
		hit.emit(body, data.normal_damage)
		play_blood_vfx()
		if sword_player:
			sword_player.play()

func _set_marker_values():
	marker_positions = {
		"Hand": {
			"L_Position": Vector3(0.036, -0.349, 0.175),
			"R_Position": Vector3(0.08, -0.247, 0.122),
			"L_Rotation": Vector3(-67.5, -90.0, 90.0),
			"R_Rotation": Vector3(67.5, -90.0, 90.0),
			},
		"Finger": {
			"L_Position": Vector3(-0.089, -0.276, -0.048),
			"R_Position": Vector3(-0.018, -0.253, -0.036),
			#"L_Position": Vector3(0.044, 0.002, 0.15),
			#"R_Position": Vector3(-0.044, 0.002, 0.15),
			"L_Rotation": Vector3(-67.5, -90.0, 90.0),
			"R_Rotation": Vector3(67.5, -90.0, 90.0),
			#"L_Rotation": Vector3.ZERO,
			#"R_Rotation": Vector3.ZERO,
			},
		"Thumb": {
			"L_Position": Vector3(0.033, -0.268, -0.025),
			"R_Position": Vector3(-0.038, -0.207, 0.036),
			"L_Rotation": Vector3.ZERO,
			"R_Rotation": Vector3.ZERO,
			},
		"FingerPole": {
			"L_Position": Vector3(-0.336, -0.288, -0.018),
			"R_Position": Vector3(0.98, -0.255, -1.199),
			"L_Rotation": Vector3.ZERO,
			"R_Rotation": Vector3.ZERO,
			},
		"ThumbPole": {
			"L_Position": Vector3(0.101, -0.187, -0.096),
			"R_Position": Vector3(-0.251, -0.049, 0.324),
			"L_Rotation": Vector3.ZERO,
			"R_Rotation": Vector3.ZERO,
			},
	}

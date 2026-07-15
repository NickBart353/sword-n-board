extends MeleeWeapon

@export var hammer_player: AudioStreamPlayer3D

signal hit

func _on_body_entered(body: Node3D) -> void:
	if body is Enemy:
		hit.emit(body, data.normal_damage)
		hammer_player.play()
		play_blood_vfx()

func _set_marker_values():
	marker_positions = {
		"Hand": {
			"L_Position": Vector3(0.0, 0.118, 0.145),
			"R_Position": Vector3(0.053, 0.115, 0.125),
			"L_Rotation": Vector3(-67.5, -90.0, 90.0),
			"R_Rotation": Vector3(67.5, -90.0, 90.0),
			},
		"Finger": {
			"L_Position": Vector3(-0.018, 0.159, -0.043),
			"R_Position": Vector3(0.013, 0.169, -0.045),
			"L_Rotation": Vector3(-67.5, -90.0, 90.0),
			"R_Rotation": Vector3(67.5, -90.0, 90.0),
			},
		"Thumb": {
			"L_Position": Vector3(0.054, 0.153, 0),
			"R_Position": Vector3(-0.044, 0.158, 0.034),
			"L_Rotation": Vector3.ZERO,
			"R_Rotation": Vector3.ZERO,
			},
		"FingerPole": {
			"L_Position": Vector3(-0.263, 0.118, -0.019),
			"R_Position": Vector3(0.192, 0.121, -0.044),
			"L_Rotation": Vector3.ZERO,
			"R_Rotation": Vector3.ZERO,
			},
		"ThumbPole": {
			"L_Position": Vector3(0.162, 0.097, 0.091),
			"R_Position": Vector3(-0.164, 0.185, 0.044),
			"L_Rotation": Vector3.ZERO,
			"R_Rotation": Vector3.ZERO,
			},
	}

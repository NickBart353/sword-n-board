extends MeleeWeapon

signal hit

const weapon_position: Dictionary = {
	"R": Vector3(0, 0, 0),
	"L": Vector3(0, 0, 0),
}

func _on_body_entered(body: Node3D) -> void:
	if body is Enemy:
		hit.emit(body, data.normal_damage)

func get_weapon_position(hand: String) -> Vector3:
	return weapon_position[hand]

func _set_marker_values():
	marker_positions = {
		"Hand": {
			"L_Position": Vector3(0, 0, 0),
			"R_Position": Vector3(0, 0, 0),
			"L_Rotation": Vector3(-67.5, -90.0, 90.0),
			"R_Rotation": Vector3(67.5, -90.0, 90.0),
			},
		"Finger": {
			"L_Position": Vector3(0.044, 0, -0.03),
			"R_Position": Vector3(-0.123, 0, -0.121),
			#"L_Position": Vector3(0.044, 0.002, 0.15),
			#"R_Position": Vector3(-0.044, 0.002, 0.15),
			"L_Rotation": Vector3(-67.5, -90.0, 90.0),
			"R_Rotation": Vector3(67.5, -90.0, 90.0),
			#"L_Rotation": Vector3.ZERO,
			#"R_Rotation": Vector3.ZERO,
			},
		"Thumb": {
			"L_Position": Vector3(0.024, 0.024, 0),
			"R_Position": Vector3(-0.19, 0.0, -0.103),
			"L_Rotation": Vector3.ZERO,
			"R_Rotation": Vector3.ZERO,
			},
		"FingerPole": {
			"L_Position": Vector3(-0.98, 0, -1.206),
			"R_Position": Vector3(0.007, 0, -0.279),
			"L_Rotation": Vector3.ZERO,
			"R_Rotation": Vector3.ZERO,
			},
		"ThumbPole": {
			"L_Position": Vector3(0.251, 0.206, 0.316),
			"R_Position": Vector3(-0.233, -0.034, -0.06),
			"L_Rotation": Vector3.ZERO,
			"R_Rotation": Vector3.ZERO,
			},
	}

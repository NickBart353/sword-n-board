class_name Shield extends MeleeWeapon

signal blocked

var monitoring: bool = false

var body_back_side_entered_first: bool = false
var area_back_side_entered_first: bool = false

func set_collision_mask_value(_value: int, _boolean: bool):
	pass

func _set_marker_values():
	marker_positions = {
		"Hand": {
			"L_Position": Vector3(-0.152, 0.119, 0.31),
			"R_Position": Vector3(0.172, 0.162, 0.229),
			"L_Rotation": Vector3(-67.5, -90.0, 90.0),
			"R_Rotation": Vector3(67.5, -90.0, 90.0),
			},
		"Finger": {
			"L_Position": Vector3(-0.011, 0.068, 0.154),
			"R_Position": Vector3(-0.06, 0.055, 0.028),
			#"L_Position": Vector3(0.044, 0.002, 0.15),
			#"R_Position": Vector3(-0.044, 0.002, 0.15),
			"L_Rotation": Vector3(-67.5, -90.0, 90.0),
			"R_Rotation": Vector3(67.5, -90.0, 90.0),
			#"L_Rotation": Vector3.ZERO,
			#"R_Rotation": Vector3.ZERO,
			},
		"Thumb": {
			"L_Position": Vector3(0.102, 0.04, 0.204),
			"R_Position": Vector3(-0.223, 0.024, 0.109),
			"L_Rotation": Vector3.ZERO,
			"R_Rotation": Vector3.ZERO,
			},
		"FingerPole": {
			"L_Position": Vector3(-0.049, 0.103, 0.16),
			"R_Position": Vector3(0.213, 0, 0.062),
			"L_Rotation": Vector3.ZERO,
			"R_Rotation": Vector3.ZERO,
			},
		"ThumbPole": {
			"L_Position": Vector3(0.205, 0.201, 0.251),
			"R_Position": Vector3(0.058, 0.206, 0.373),
			"L_Rotation": Vector3.ZERO,
			"R_Rotation": Vector3.ZERO,
			},
	}

func _on_sketchfab_model_body_entered(body: Node3D) -> void:
	hit_body(body)

func _on_body_entered(body: Node3D) -> void:
	hit_body(body)

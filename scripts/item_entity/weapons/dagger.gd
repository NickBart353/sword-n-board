class_name Dagger extends MeleeWeapon

signal hit

const weapon_data: Dictionary = {
	"R_POSITION": Vector3(-0.073, -0.133, -0.109),
	"R_ROTATION": Vector3(-66.7, -77.0, -143.8),
	"R_PARRY_POSITION": Vector3(-0.183, 0.122, -0.084),
	"R_PARRY_ROTATION": Vector3(-13.6, 46.8, 19.9),
	"R_COLLISION_POSITION": Vector3(-0.217, 0.202, -0.079),
	"R_COLLISION_ROTATION": Vector3(-22.0, 74.8, 11.7),
	"L_POSITION": Vector3(0.022, -0.148, -0.15),
	"L_ROTATION": Vector3(-66.3, 72.8, -15.0),
	"L_PARRY_POSITION": Vector3(0.126, 0.1, -0.116),
	"L_PARRY_ROTATION": Vector3(3.5, 150.2, 23.2),
	"L_COLLISION_POSITION": Vector3(0.172, 0.197, -0.101),
	"L_COLLISION_ROTATION": Vector3(-18.8, -147.7, 15.2),
}

func _on_body_entered(body: Node3D) -> void:
	if body is Enemy:
		hit.emit(body, data.normal_damage)

func set_weapon_position(hand: String) -> void:
	$DaggerMesh.position = weapon_data["{0}_POSITION".format(hand)]
	$DaggerMesh.rotation = weapon_data["{0}_ROTATION".format(hand)]
	$CollisionShape3D.position = weapon_data["{0}_PARRY_POSITION".format(hand)]
	$CollisionShape3D.rotation = weapon_data["{0}_PARRY_ROTATION".format(hand)]
	$ParryComponent/CollisionShape3D.position = weapon_data["{0}_COLLISION_POSITION".format(hand)]
	$ParryComponent/CollisionShape3D.rotation = weapon_data["{0}_COLLISION_ROTATION".format(hand)]

func get_weapon_position(hand: String) -> Vector3:
	return weapon_data["{0}_POSITION".format(hand)]

func get_weapon_rotation(hand: String) -> Vector3:
	return weapon_data["{0}_ROTATION".format(hand)]

func _set_marker_values():
	marker_positions = {
		"Hand": {
			"L_Position": Vector3(0, 0, 0),
			"R_Position": Vector3(0, 0, 0),
			"L_Rotation": Vector3(-67.5, -90.0, 90.0),
			"R_Rotation": Vector3(67.5, -90.0, 90.0),
			},
		"Finger": {
			"L_Position": Vector3(0.089, -0.033, -0.163),
			"R_Position": Vector3(-0.123, 0, -0.121),
			#"L_Position": Vector3(0.044, 0.002, 0.15),
			#"R_Position": Vector3(-0.044, 0.002, 0.15),
			"L_Rotation": Vector3(-67.5, -90.0, 90.0),
			"R_Rotation": Vector3(67.5, -90.0, 90.0),
			#"L_Rotation": Vector3.ZERO,
			#"R_Rotation": Vector3.ZERO,
			},
		"Thumb": {
			"L_Position": Vector3(0.122, -0.062, -0.183),
			"R_Position": Vector3(-0.19, 0.0, -0.103),
			"L_Rotation": Vector3.ZERO,
			"R_Rotation": Vector3.ZERO,
			},
		"FingerPole": {
			"L_Position": Vector3(-0.038, 0, -0.254),
			"R_Position": Vector3(0.007, 0, -0.279),
			"L_Rotation": Vector3.ZERO,
			"R_Rotation": Vector3.ZERO,
			},
		"ThumbPole": {
			"L_Position": Vector3(0.208, 0.004, -0.038),
			"R_Position": Vector3(-0.233, -0.034, -0.06),
			"L_Rotation": Vector3.ZERO,
			"R_Rotation": Vector3.ZERO,
			},
	}

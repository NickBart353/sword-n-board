class_name Shield extends MeleeWeapon

signal blocked
signal hit

var monitoring: bool = false

@onready var front_side: Area3D = $Sketchfab_model
@onready var back_side: Area3D = $Backside
@onready var block_player: AudioStreamPlayer3D = $BlockPlayer

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
	if body is Enemy:
		hit.emit(body, data.normal_damage)
	#if body is Terrain3D: return
	#if not body_back_side_entered_first:
		#blocked.emit(body)
		##block_player.play()
	#body_back_side_entered_first = false

func _on_backside_body_entered(_body: Node3D) -> void:
	pass
	#if _body is Terrain3D: return
	#body_back_side_entered_first = true

func _on_sketchfab_model_area_entered(_area: Area3D) -> void:
	pass
	#if not area_back_side_entered_first:
	#blocked.emit(area)
	#block_player.play()
	#area_back_side_entered_first = false

func activate_areas():
	front_side.monitorable = true
	back_side.monitorable = true

func deactivate_areas():
	front_side.monitorable = false
	back_side.monitorable = false

#func _on_backside_area_entered(_area: Area3D) -> void:
	#area_back_side_entered_first = true

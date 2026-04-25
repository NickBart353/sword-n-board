extends MeleeWeapon

@onready var hand_markers: Node3D = $HandMarkers

@export var sword_player: AudioStreamPlayer3D

signal hit

var marker_positions: Dictionary = {
	"Hand": {
		"L_Position": Vector3(-0.035, 0, 0.15),
		"R_Position": Vector3(0.035, 0, 0.15),
		"L_Rotation": Vector3(-67.5, -90.0, 90.0),
		"R_Rotation": Vector3(67.5, -90.0, 90.0),
		},
	"Finger": {
		"L_Position": Vector3(0.044, 0.002, 0.15),
		"R_Position": Vector3(-0.044, 0.002, 0.15),
		"L_Rotation": Vector3(-67.5, -90.0, 90.0),
		"R_Rotation": Vector3(67.5, -90.0, 90.0),
		},
	"Thumb": {
		"L_Position": Vector3(0.024, 0.024, 0),
		"R_Position": Vector3(-0.024, 0.024, 0),
		"L_Rotation": Vector3.ZERO,
		"R_Rotation": Vector3.ZERO,
		},
	"FingerPole": {
		"L_Position": Vector3(-0.98, 0, -1.206),
		"R_Position": Vector3(0.98, 0, -1.206),
		"L_Rotation": Vector3.ZERO,
		"R_Rotation": Vector3.ZERO,
		},
	"ThumbPole": {
		"L_Position": Vector3(0.251, 0.206, 0.316),
		"R_Position": Vector3(-0.251, 0.206, 0.316),
		"L_Rotation": Vector3.ZERO,
		"R_Rotation": Vector3.ZERO,
		},
}

func _ready() -> void:
	pass

func _on_body_entered(body: Node3D) -> void:
	if body is Enemy:
		hit.emit(body, data.normal_damage)
		sword_player.play()

func get_weapon_markers() -> Node3D:
	return hand_markers

func get_hand() -> Marker3D:
	return $HandMarkers/Hand

func get_finger() -> Marker3D:
	return $HandMarkers/Finger

func get_thumb() -> Marker3D:
	return $HandMarkers/Thumb

func get_finger_pole() -> Marker3D:
	return $HandMarkers/FingerPole

func get_thumb_pole() -> Marker3D:
	return $HandMarkers/ThumbPole

func update_markers(hand: String) -> void:
	for marker: Marker3D in hand_markers.get_children():
		marker.position = marker_positions[marker]["{0}_Position".format(hand)]
		marker.rotation = marker_positions[marker]["{0}_Rotation".format(hand)]

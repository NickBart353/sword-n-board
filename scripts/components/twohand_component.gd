extends Node3D

@export var left_hand: Node3D
@export var right_hand: Node3D

@onready var l_hand: Marker3D = $LeftHand/Hand
@onready var l_finger: Marker3D = $LeftHand/Finger
@onready var l_thumb: Marker3D = $LeftHand/Thumb
@onready var l_finger_pole: Marker3D = $LeftHand/FingerPole
@onready var l_thumb_pole: Marker3D = $LeftHand/ThumbPole

@onready var r_hand: Marker3D = $RightHand/Hand
@onready var r_finger: Marker3D = $RightHand/Finger
@onready var r_thumb: Marker3D = $RightHand/Thumb
@onready var r_finger_pole: Marker3D = $RightHand/FingerPole
@onready var r_thumb_pole: Marker3D = $RightHand/ThumbPole

func update_markers(_side: String, marker_dictionary: Dictionary):
	for marker in left_hand.get_children():
		marker.position = marker_dictionary.get(marker.name).get("L_Position")
		marker.rotation = marker_dictionary.get(marker.name).get("L_Rotation")
	for marker in right_hand.get_children():
		marker.position = marker_dictionary.get(marker.name).get("R_Position")
		marker.rotation = marker_dictionary.get(marker.name).get("R_Rotation")

func get_markers() -> Dictionary:
	return {
		"L": {
				"Hand": l_hand,
				"Finger": l_finger,
				"Thumb": l_thumb,
				"FingerPole": l_finger_pole,
				"ThumbPole": l_thumb_pole,
				},
		"R": {
				"Hand": r_hand,
				"Finger": r_finger,
				"Thumb": r_thumb,
				"FingerPole": r_finger_pole,
				"ThumbPole": r_thumb_pole,
				},
			}

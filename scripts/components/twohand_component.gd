extends Node3D

@onready var left_hand: Node3D = $LeftHand
@onready var right_hand: Node3D = $RightHand

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
	for marker: Marker3D in left_hand.get_children():
		marker.position = marker_dictionary[marker]["{0}_Position".format("L")]
		marker.rotation = marker_dictionary[marker]["{0}_Rotation".format("L")]
	for marker: Marker3D in right_hand.get_children():
		marker.position = marker_dictionary[marker]["{0}_Position".format("R")]
		marker.rotation = marker_dictionary[marker]["{0}_Rotation".format("R")]

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

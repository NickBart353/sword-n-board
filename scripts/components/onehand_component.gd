extends Node3D

@onready var hand: Marker3D = $Hand
@onready var finger: Marker3D = $Finger
@onready var thumb: Marker3D = $Thumb
@onready var finger_pole: Marker3D = $FingerPole
@onready var thumb_pole: Marker3D = $ThumbPole

func update_markers(side: String, marker_dictionary: Dictionary):
	for marker: Marker3D in get_children():
		marker.position = marker_dictionary[marker]["{0}_Position".format(side)]
		marker.rotation = marker_dictionary[marker]["{0}_Rotation".format(side)]

func get_markers() -> Dictionary:
	return {
				"Hand": hand,
				"Finger": finger,
				"Thumb": thumb,
				"FingerPole": finger_pole,
				"ThumbPole": thumb_pole,
			}

extends Node3D

@export var hand: Marker3D
@export var finger: Marker3D
@export var thumb: Marker3D
@export var finger_pole: Marker3D
@export var thumb_pole: Marker3D

func update_markers(side: String, marker_dictionary: Dictionary):
	for marker in get_children():
		marker.position = marker_dictionary.get(marker.name).get("{0}_Position".format([side]))
		marker.rotation = marker_dictionary.get(marker.name).get("{0}_Rotation".format([side]))

func get_markers() -> Dictionary:
	return {
				"Hand": hand,
				"Finger": finger,
				"Thumb": thumb,
				"FingerPole": finger_pole,
				"ThumbPole": thumb_pole,
			}

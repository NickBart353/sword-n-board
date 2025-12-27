extends Node3D

func _process(_delta: float) -> void:
	$Entrance/BlackSquare/Outline.set_visible(false)

func interact():
	print("entering dungeon...")

func hover():
	if not is_visible():
		$Entrance/BlackSquare/Outline.set_visible(true)

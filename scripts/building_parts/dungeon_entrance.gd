extends Node3D

func _process(_delta: float) -> void:
	pass#$Entrance/BlackSquare/Outline.set_visible(false)

func interact():
	print("entering dungeon...")

func hover():
	if not $Entrance/BlackSquare/Outline.is_visible():
		$Entrance/BlackSquare/Outline.set_visible(true)

func un_hover():
	if $Entrance/BlackSquare/Outline.is_visible():
		$Entrance/BlackSquare/Outline.set_visible(false)

extends Node3D

func _ready() -> void:
	$Interactable._interact.connect(interact)
	$Interactable._hover.connect(hover)
	$Interactable._un_hover.connect(un_hover)

func hover():
	#if not $Entrance/BlackSquare/Outline.is_visible():
		#$Entrance/BlackSquare/Outline.set_visible(true)
	if not $Sprite3D.is_visible():
		$Sprite3D.set_visible(true)

func un_hover():
	#if $Entrance/BlackSquare/Outline.is_visible():
		#$Entrance/BlackSquare/Outline.set_visible(false)
	if $Sprite3D.is_visible():
		$Sprite3D.set_visible(false)

func interact():
	print("enter dungeon")
	get_tree().change_scene_to_file("res://scenes/main_scenes/dungeon_level.tscn")

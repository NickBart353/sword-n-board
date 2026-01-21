extends Node3D

func _ready() -> void:
	$Interactable._interact.connect(interact)

func interact():
	print("entering dungeon...")
	get_tree().change_scene_to_file("res://scenes/main_scenes/dungeon_level.tscn")

extends Node3D

@onready var interactable: Interactable = $Interactable
@export var disble_entrance: bool = true

func _ready() -> void:
	interactable._interact.connect(interact)
	if disble_entrance:
		interactable.hover_text = "Entrance Disabled"

func interact():
	if not disble_entrance:
		get_tree().change_scene_to_file("res://scenes/main_scenes/dungeon_level.tscn")

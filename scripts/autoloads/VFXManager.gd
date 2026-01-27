extends Node

signal create_explosion

const POISON_EXPLOSION: PackedScene = preload("res://scenes/VFX/poison_explosion.tscn")

func _ready() -> void:
	pass # Replace with function body.

func create_poison_explosion(position: Vector3):
	create_explosion.emit(position, POISON_EXPLOSION)

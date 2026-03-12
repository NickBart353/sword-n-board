extends MeleeWeapon

@export var sword_player: AudioStreamPlayer3D

signal hit

func _ready() -> void:
	pass#data = preload("res://resources/items/iron_sword.tres")

func _on_body_entered(body: Node3D) -> void:
	if body is Enemy:
		hit.emit(body, data.damage)
		sword_player.play()

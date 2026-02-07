extends MeleeWeapon

signal hit

func _ready() -> void:
	data = preload("res://resources/items/iron_sword.tres")

func _on_body_entered(body: Node3D) -> void:
	if body is Enemy:
		hit.emit(body, data.damage)

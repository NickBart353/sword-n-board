extends MagicWeapon

signal hit

var knockbackStrength_vertical: int = 2
var knockbackStrength_horizontal: int = 5
var damage: int = 25

func _on_body_entered(body: Node3D) -> void:
	if body is Enemy:
		hit.emit(body, damage)

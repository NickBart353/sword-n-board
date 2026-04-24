extends MeleeWeapon

@export var sword_player: AudioStreamPlayer3D

signal hit

func _ready() -> void:
	pass

func _on_body_entered(body: Node3D) -> void:
	if body is Enemy:
		hit.emit(body, data.normal_damage)
		sword_player.play()

func get_weapon_markers() -> Marker3D:
	return $HandMarkers/HandMarker

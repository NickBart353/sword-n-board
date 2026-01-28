extends Node3D

func _ready() -> void:
	$AnimationPlayer.play("Scream")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Scream":
		queue_free()

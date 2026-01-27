extends Node3D

func _ready() -> void:
	$AnimationPlayer.play("Explosion")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Explosion":
		queue_free()

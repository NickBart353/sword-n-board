extends Node3D

func _ready() -> void:
	$AnimationPlayer.play("Charge")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Charge":
		queue_free()

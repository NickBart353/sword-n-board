extends Node3D

var animation_playing: bool = false

func _ready() -> void:
	$AnimationPlayer.play("default")

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	queue_free()

func _on_animation_player_animation_started(_anim_name: StringName) -> void:
	if not animation_playing:
		animation_playing = true
	else:
		$AnimationPlayer.stop()

func _remove_mesh():
	$MeshInstance3D.hide()

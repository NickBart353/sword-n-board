class_name Basic_VFX extends Node3D

@export var animation_player: AnimationPlayer
@export var animation_name: String

func _ready() -> void:
	animation_player.play(animation_name)
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == animation_name:
		queue_free()

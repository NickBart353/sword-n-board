extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func play_charge_animation(new_speed):
	animation_player.speed_scale = new_speed
	animation_player.play("charge")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "charge":
		animation_player.play("RESET")

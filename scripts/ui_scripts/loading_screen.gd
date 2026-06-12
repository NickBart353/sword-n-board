extends CanvasLayer

signal loading_screen_ready

@export var anim_player: AnimationPlayer

func _ready() -> void:
	await anim_player.animation_finished
	loading_screen_ready.emit()
	#anim_player.play("spinny")
	#var transition_tween: Tween = get_tree().create_tween()
	#transition_tween.tween_property($Panel, "modulate", Color.RED, 1.0)
	#await anim_player.animation_finished

func _on_progress_changed(_new_value: float) -> void:
	pass

func _on_load_finished() -> void:
	#anim_player.play("transition_reversed")
	anim_player.play_backwards("transition")
	#$SpinnyPlayer.stop()
	#$Spinner.hide()
	await anim_player.animation_finished
	queue_free()

#func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	#if anim_name == "transition":
		#loading_screen_ready.emit()
	#if anim_name == "transition_reversed":
		#queue_free()

extends CanvasLayer

signal loading_screen_ready

@export var anim_player: AnimationPlayer

func _ready() -> void:
	#var transition_tween: Tween = get_tree().create_tween()
	#transition_tween.tween_property($Panel, "modulate", Color.RED, 1.0)
	await anim_player.animation_finished
	loading_screen_ready.emit()

func _on_progress_changed(new_value: float) -> void:
	pass

func _on_load_finished() -> void:
	anim_player.play_backwards("transition")
	await anim_player.animation_finished
	queue_free()

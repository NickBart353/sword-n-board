extends CanvasLayer

signal loading_screen_ready

@export var anim_player: AnimationPlayer

func _ready() -> void:
	print("waiting... loading_screen.gd")
	anim_player.play("transition")
	if anim_player.is_playing():
		await anim_player.animation_finished
	loading_screen_ready.emit()

func _on_progress_changed(_new_value: float) -> void:
	print("progress chage... loading_screen.gd")
	pass

func _on_load_finished() -> void:
	print("load finished... loading_screen.gd")
	anim_player.play_backwards("transition")
	await anim_player.animation_finished
	queue_free()

extends Node3D

@onready var anim_player = $AnimationPlayer

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("attack"):
		if anim_player.current_animation != "swang":
			anim_player.play("swang")

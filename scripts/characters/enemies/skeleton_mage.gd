extends Node3D

@onready var anim_player = $skeleton_mage/AnimationPlayer

func _process(_delta: float) -> void:
	if anim_player.current_animation != "Idle":
		anim_player.play("Idle")

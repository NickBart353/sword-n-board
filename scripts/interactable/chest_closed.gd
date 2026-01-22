class_name Chest
extends StaticBody3D

signal remove_me
var open: bool = false
var in_motion = false

func _ready() -> void:
	$ItemContainer.items_empty.connect(_remove_me)
	$ItemContainer.parent = name
	$ItemContainer._interact.connect(interact)

func _remove_me():
	remove_me.emit(self)

func interact():
	if not in_motion:
		in_motion = true
		$AnimationPlayer.play("open_chest")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "open_chest":
		$AnimationPlayer.play("close_chest")
	if anim_name == "close_chest":
		in_motion = false

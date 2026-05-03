extends StaticBody3D
class_name DoorWay

var open = false
var in_motion = false
var hovered = false
var all_animations_finished: int

func _ready() -> void:
	$Interactable._interact.connect(interact)

func interact():
	if $AnimationPlayer.is_playing():
		return
	if open and not in_motion:
		open = false
		in_motion = true
		$Interactable.refresh_text("Open door")
		$AnimationPlayer.play("close_door")
	elif not open and not in_motion:
		open = true
		in_motion = true
		$Interactable.refresh_text("Close door")
		$AnimationPlayer.play("open_door")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "close_door":
		in_motion = false
	elif anim_name == "open_door":
		in_motion = false

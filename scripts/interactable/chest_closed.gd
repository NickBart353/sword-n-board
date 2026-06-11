class_name ClosedChest extends Chest

var open: bool = false
var in_motion = false

func _ready() -> void:
	super()
	$ItemContainer.parent = self
	$ItemContainer._interact.connect(interact)

func interact():
	if not in_motion:
		in_motion = true
		$AnimationPlayer.play("open_chest")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "open_chest":
		$AnimationPlayer.play("close_chest")
	if anim_name == "close_chest":
		in_motion = false

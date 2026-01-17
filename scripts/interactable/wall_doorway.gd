extends StaticBody3D
class_name DoorWay

var open = false
var in_motion = false
var hovered = false
var all_animations_finished: int

func _ready() -> void:
	$Interactable._interact.connect(interact)
	$Interactable._hover.connect(hover)
	$Interactable._un_hover.connect(un_hover)

func hover():
	#if not $Entrance/BlackSquare/Outline.is_visible():
		#$Entrance/BlackSquare/Outline.set_visible(true)
	hovered = true
	if not $Text_Rotator/Text.is_visible():
		$Text_Rotator/Text.set_visible(true)

func un_hover():
	#if $Entrance/BlackSquare/Outline.is_visible():
		#$Entrance/BlackSquare/Outline.set_visible(false)
	if hovered:
		$Text_Rotator/Text.set_visible(false)
		open = false
		hovered = false

func interact():
	if not in_motion:
		in_motion = true
		var rotation_val: int
		
		if open:
			open = false
			rotation_val = 160
			$Node3D/SubViewport/Label.text = "Press E to close door."
		else:
			open = true
			rotation_val = -160
			$Node3D/SubViewport/Label.text = "Press E to open door."
			
		var door   = $wall_doorway2/wall_doorway/wall_doorway_door
		var hitbox = $DoorHitbox
		
		var tween_door = create_tween()
		var tween_hitbox = create_tween()
		
		tween_door.tween_property(door, "rotation_degrees:y", door.rotation_degrees.y + rotation_val, 0.5)
		tween_hitbox.tween_property(hitbox, "rotation_degrees:y", hitbox.rotation_degrees.y + rotation_val, 0.5)
		
		tween_door.finished.connect(_on_tween_finished)
		tween_hitbox.finished.connect(_on_tween_finished)
		
		all_animations_finished = 2

func _on_tween_finished():
	all_animations_finished -= 1
	if all_animations_finished == 0:
		in_motion = false

extends Area3D

@export var area: LoopMixer.AREA = LoopMixer.AREA.FOREST

func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		LoopMixer.transition_to_new_area(area)

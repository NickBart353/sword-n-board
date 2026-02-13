extends Shield

signal blocked

var body_back_side_entered_first: bool = false
var area_back_side_entered_first: bool = false

func _on_sketchfab_model_body_entered(body: Node3D) -> void:
	if body is Terrain3D: return
	if not body_back_side_entered_first:
		blocked.emit(body)
	body_back_side_entered_first = false

func _on_backside_body_entered(_body: Node3D) -> void:
	if _body is Terrain3D: return
	body_back_side_entered_first = true

func _on_sketchfab_model_area_entered(area: Area3D) -> void:
	#if not area_back_side_entered_first:
	blocked.emit(area)
	#area_back_side_entered_first = false

#func _on_backside_area_entered(_area: Area3D) -> void:
	#area_back_side_entered_first = true

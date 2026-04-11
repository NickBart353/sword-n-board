class_name Shield extends MeleeWeapon

signal blocked
signal hit

@onready var front_side: Area3D = $Sketchfab_model
@onready var back_side: Area3D = $Backside
@onready var block_player: AudioStreamPlayer3D = $BlockPlayer

var body_back_side_entered_first: bool = false
var area_back_side_entered_first: bool = false

func set_collision_mask_value(value: int, boolean: bool):
	pass

func _on_sketchfab_model_body_entered(body: Node3D) -> void:
	if body is Enemy:
		hit.emit(body, data.normal_damage)
	if body is Terrain3D: return
	if not body_back_side_entered_first:
		blocked.emit(body)
		#block_player.play()
	body_back_side_entered_first = false

func _on_backside_body_entered(_body: Node3D) -> void:
	if _body is Terrain3D: return
	body_back_side_entered_first = true

func _on_sketchfab_model_area_entered(area: Area3D) -> void:
	#if not area_back_side_entered_first:
	blocked.emit(area)
	#block_player.play()
	#area_back_side_entered_first = false

func activate_areas():
	front_side.monitorable = true
	back_side.monitorable = true

func deactivate_areas():
	front_side.monitorable = false
	back_side.monitorable = false

#func _on_backside_area_entered(_area: Area3D) -> void:
	#area_back_side_entered_first = true

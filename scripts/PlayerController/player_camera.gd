extends Camera3D

@export var camera_tracking_position: Node3D
@export var transition_speed: float = 10.0
@export var max_y_distance: float = 0.5

var tracking: bool = true

func _ready() -> void:
	top_level = true
	if camera_tracking_position:
		global_position = camera_tracking_position.global_position

func stop_tracking() -> void:
	tracking = false

func continue_tracking() -> void:
	tracking = true

func _physics_process(delta: float) -> void:
	if not camera_tracking_position or not tracking:
		return
	
	var target_pos = camera_tracking_position.global_position
	
	global_position.x = target_pos.x
	global_position.z = target_pos.z
	
	var smoothed_y = lerpf(global_position.y, target_pos.y, 1.0 - exp(-transition_speed * delta))
	
	var current_y_offset = smoothed_y - target_pos.y
	var clamped_offset = clamp(current_y_offset, -max_y_distance, max_y_distance)
	
	global_position.y = target_pos.y + clamped_offset

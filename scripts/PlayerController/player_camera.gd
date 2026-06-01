extends Camera3D

@export var camera_tracking_position: Node
@export var transition_speed: float = 10.0

func _ready() -> void:
	top_level = true
	global_position = camera_tracking_position.global_position
	clear_current()

func _physics_process(delta: float) -> void:
	global_position.x = camera_tracking_position.global_position.x
	global_position.z = camera_tracking_position.global_position.z
	global_position.y = lerpf(global_position.y, camera_tracking_position.global_position.y, delta * 10)
	

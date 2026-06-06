class_name BlockingComponent extends Area3D

signal blocked

@export var blocking_type: BLOCKING_TYPE

enum BLOCKING_TYPE {Light, Medium, Strong}

func _ready() -> void:
	if not body_entered.is_connected(_on_enemy_entered):
		body_entered.connect(_on_enemy_entered)
	if not area_entered.is_connected(_on_enemy_entered):
		area_entered.connect(_on_enemy_entered)

func _on_enemy_entered(body: Node3D) -> void:
	blocked.emit(body, blocking_type)

func disable_monitoring():
	monitoring = false

func enable_monitoring():
	monitoring = true

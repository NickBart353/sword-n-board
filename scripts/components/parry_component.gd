class_name ParryComponent extends Area3D

signal parried

func _ready() -> void:
	if not body_entered.is_connected(_on_enemy_entered):
		body_entered.connect(_on_enemy_entered)
	if not area_entered.is_connected(_on_enemy_entered):
		area_entered.connect(_on_enemy_entered)

func _on_enemy_entered(body: Node3D) -> void:
	parried.emit(body)

func disable_monitoring():
	monitoring = false

func enable_monitoring():
	monitoring = true

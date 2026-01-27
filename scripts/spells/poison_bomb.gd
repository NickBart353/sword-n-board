extends Area3D

@export var bomb_speed = 10

signal exploded

var fired_from: Vector3 = Vector3.ZERO
var damage: int = 10

func _physics_process(delta: float) -> void:
	var gravity = get_gravity()

func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		body.take_damage(damage, self)
	exploded.emit(self)

func _on_area_entered(_area: Area3D) -> void:
	exploded.emit(self)

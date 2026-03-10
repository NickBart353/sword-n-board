extends Area3D

@export var damage: int  = 20

@onready var anim_player: AnimationPlayer = $AnimationPlayer

signal slam_finished

var hit: bool = true

func _ready() -> void:
	monitoring = true

func play_slam(new_damage: int):
	damage = new_damage
	anim_player.play("slam")

func deactivate_slam():
	monitoring = false

func _on_body_entered(body: Node3D) -> void:
	if not hit and (body is Player or body is Enemy):
		hit = true
		body.take_damage(damage, self)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "slam":
		slam_finished.emit(self)

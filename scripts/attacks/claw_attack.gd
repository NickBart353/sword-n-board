extends Area3D

@export var damage: int  = 20

@onready var anim_player: AnimationPlayer = $AnimationPlayer

signal claw_finished

var hit: bool = false

func _ready() -> void:
	monitoring = false

func play_claw(new_transform: Transform3D, new_damage: int):
	damage = new_damage
	if new_transform:
		transform = new_transform
	anim_player.play("swipe")

func _on_body_entered(body: Node3D) -> void:
	if not hit and (body is Player or body is Enemy):
		hit = true
		body.take_damage(damage, self)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "swipe":
		claw_finished.emit(self)

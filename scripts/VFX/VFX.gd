class_name Basic_VFX extends Node3D

@export var animation_player: AnimationPlayer
@export var animation_name: String
@export var enable_gravity: bool = false

var gravity: Vector3 = Vector3(0.0, -1.0, 0)

func _ready() -> void:
	animation_player.play(animation_name)
	if not animation_player.animation_finished.is_connected(_on_animation_player_animation_finished):
		animation_player.animation_finished.connect(_on_animation_player_animation_finished)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == animation_name:
		queue_free()

func _physics_process(delta: float) -> void:
	global_translate(gravity * delta)

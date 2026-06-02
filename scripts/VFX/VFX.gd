class_name Basic_VFX extends Node3D

signal vfx_finished

@export var animation_player: AnimationPlayer
@export var animation_name: String
@export var enable_gravity: bool = false
@export var queue_free_on_finish: bool = false
@export var hide_if_missed_by_player: bool = true

var gravity: Vector3 = Vector3(0.0, -1.0, 0)

func _ready() -> void:
	hide()
	if not animation_player.animation_finished.is_connected(_on_animation_player_animation_finished):
		animation_player.animation_finished.connect(_on_animation_player_animation_finished)

func play() -> void:
	show()
	#TODO FIX ANIMATION
	animation_player.play(animation_name)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == animation_name:
		hide()
		if queue_free_on_finish:
			queue_free()
		vfx_finished.emit()
		animation_player.play("RESET")

func _physics_process(delta: float) -> void:
	if enable_gravity:
		global_translate(gravity * delta)

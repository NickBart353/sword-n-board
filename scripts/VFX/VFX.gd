class_name Basic_VFX extends Node3D

signal vfx_finished

@export var animation_player: AnimationPlayer
@export var animation_name: String
@export var enable_gravity: bool = false
@export var queue_free_on_finish: bool = false
@export var hide_if_missed_by_player: bool = true
@export_range(0.0, 1000.0) var distance_needed_to_not_play: float = 50.0

var player: CharacterBody3D 
var gravity: Vector3 = Vector3(0.0, -1.0, 0)

func _ready() -> void:
	hide()
	player = get_tree().get_first_node_in_group("Player")
	if not animation_player.animation_finished.is_connected(_on_animation_player_animation_finished):
		animation_player.animation_finished.connect(_on_animation_player_animation_finished)

func play() -> void:
	#hide_if_missed_by_player = false
	if hide_if_missed_by_player:
		#if player:
		#	if global_position.distance_to(player.global_position) > distance_needed_to_not_play:
		if not PlayerControls.is_position_in_frustrum(global_position):
			if queue_free_on_finish:
				queue_free()
			else:
				hide()
			vfx_finished.emit()
			return
	show()
	animation_player.play(animation_name)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == animation_name:
		hide()
		vfx_finished.emit()
		animation_player.play("RESET")
		if queue_free_on_finish:
			queue_free()

func _physics_process(delta: float) -> void:
	if enable_gravity:
		global_translate(gravity * delta)

extends Node3D

signal slammed

@onready var anim_tree = $AnimationTree["parameters/playback"]
@export_range(0.0, 100.0) var idle_blend_speed: float = 2.0
@export_range(0.0, 100.0) var slam_blend_speed: float = 2.0

@export var damage: int = 30
var hit: bool = false
var windup: bool = false
var slamming: bool = false
var idling: bool = false
var can_take_damage: bool = false
var rewind: bool = false

func _ready() -> void:
	anim_tree.state_finished.connect(_state_finished)
	anim_tree.state_started.connect(_state_started)

func slam() -> void:
	hit = false
	anim_tree.travel("SLAM")

func wind_up() -> void:
	idling = false
	windup = true

func re_wind() -> void:
	rewind = true

func idle() -> void:
	idling = true

func _on_start_segment_body_entered(body: Node3D) -> void:
	_check_hit(body)

func _on_middle_one_segment_body_entered(body: Node3D) -> void:
	_check_hit(body)

func _on_middle_two_segment_body_entered(body: Node3D) -> void:
	_check_hit(body)

func _on_end_segment_body_entered(body: Node3D) -> void:
	_check_hit(body)

func _check_hit(body: Node3D):
	if not hit and can_take_damage and (body is Enemy or body is Player):
		hit = true
		body.take_damage(damage, self)

func _state_finished(state: StringName) -> void:
	match state:
		"WindUp":
			can_take_damage = true
		"ReWind":
			can_take_damage = true
		"SLAM":
			can_take_damage = false

func _state_started(state: StringName) -> void:
	match state:
		"WindUp":
			slamming = true
			windup = false
		"ReWind":
			slamming = true
			rewind = false
		"SLAM":
			slamming = false
			slammed.emit()

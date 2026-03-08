extends Node3D

signal slammed
signal winding

@onready var anim_tree = $AnimationTree["parameters/playback"]
@onready var impact_points: Array = [$StartSegment/StartImpact, $StartSegment/MiddleOneSegment/MiddleOneImpact, $StartSegment/MiddleOneSegment/MiddleTwoSegment/MiddleTwoImpact, $StartSegment/MiddleOneSegment/MiddleTwoSegment/EndSegment/EndImpact]

@export var damage: int = 30

var hit: bool = false
var windup: bool = false
var slamming: bool = false
var idling: bool = false
var can_take_damage: bool = false
var dead: bool = false

func _ready() -> void:
	anim_tree.state_started.connect(_state_started)

func wind_up() -> void:
	idling = false
	windup = true
	anim_tree.travel("WindUp")

func re_wind() -> void:
	windup = true
	anim_tree.travel("ReWind")

func idle() -> void:
	idling = true
	anim_tree.travel("Return")

func _state_started(state: StringName) -> void:
	can_take_damage = false
	match state:
		"WindUp", "ReWind":
			slamming = true
			windup = false
			winding.emit()
			anim_tree.travel("SLAM")
		"SLAM":
			hit = false
			can_take_damage = true
			slamming = false
			slammed.emit()

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

func create_impact_vfx():
	for impact_point in impact_points:
		VfxManager.create_vfx_from_enum(VfxManager.VFX.LINE_GROUND_IMPACT, impact_point.global_position)

func die():
	hit = false
	windup = false
	slamming = false
	idling = false
	can_take_damage = false
	dead = true
	anim_tree.travel("Dead")

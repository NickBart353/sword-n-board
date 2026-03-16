class_name DOT extends Area3D

@export_range(0.0, 10.0) var tick_speed: float = 1.0
@export var dot_damage: float = 5
@export var dot_effect_name: String

var timer: Timer
var overlapping_areas: Array[DOT]

func _ready() -> void:
	timer = Timer.new()
	add_child(timer)
	timer.one_shot = true

func _process(_delta: float) -> void:
	if not timer.time_left:
		for area in get_overlapping_areas():
			if area is DOT and area.dot_effect_name == dot_effect_name:
				overlapping_areas.append(area)
		for body in get_overlapping_bodies():
			if (body is Player or body is Enemy):
				for dot in overlapping_areas:
					if dot:
						dot.start_timer_from_overlap()
				timer.start(tick_speed)
				body.take_damage(dot_damage, self)

func start_timer_from_overlap():
	if not timer.time_left:
		timer.start(tick_speed)

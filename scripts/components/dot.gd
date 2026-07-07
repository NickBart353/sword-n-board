class_name DOT extends Area3D

signal dot_finished
signal faded

@onready var emitting_goo: GPUParticles3D = $EmittingGoo
@onready var explosion: GPUParticles3D = $GPUParticles3D

@export_range(0.0, 10.0) var tick_speed: float = 1.0
@export var dot_damage: float = 5
@export var dot_effect_name: String
@export_range(0.0, 100.0) var dot_duration: float = 10
@export var queue_free_on_finished: bool = false
@export var decal: Decal
@export var particle_effect: GPUParticles3D
@export var duration_timer: Timer

var timer: Timer
var overlapping_areas: Array[DOT]

func _ready() -> void:
	timer = Timer.new()
	add_child(timer)
	timer.one_shot = true
	duration_timer.wait_time = dot_duration
	if not duration_timer.timeout.is_connected(_on_duration_timeout):
		duration_timer.timeout.connect(_on_duration_timeout)
	set_deferred("monitoring", false)
	set_deferred("monitorable", false)
	if decal:
		decal.albedo_mix = 0
	if particle_effect:
		particle_effect.emitting = false
	hide()

func activate(activate_explosion:bool = false):
	set_deferred("monitoring", true)
	set_deferred("monitorable", true)
	duration_timer.start()
	show()
	if decal:
		decal.albedo_mix = 1
	if particle_effect:
		particle_effect.restart()
	if activate_explosion:
		explosion.restart()
	Camera3D


func _process(_delta: float) -> void:
	if monitoring:
		if timer.time_left <= 0.0:
			overlapping_areas.clear()
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

func _on_duration_timeout() -> void:
	if queue_free_on_finished:
		queue_free()
	else:
		hide()
		if decal:
			decal.albedo_mix = 0
		if particle_effect:
			particle_effect.emitting = false
		dot_finished.emit()

func fade_out() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(decal, "modulate", Color(1.691, 0.912, 1.6, 0.0), 0.3)
	tween.tween_property(emitting_goo, "transparency", 0.0, 0.3)
	faded.emit()

func fade_in() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(decal, "modulate", Color(1.691, 0.909, 1.6), 0.3)
	tween.tween_property(emitting_goo, "transparency", 1, 0.3)

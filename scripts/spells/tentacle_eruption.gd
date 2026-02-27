extends Area3D

@onready var resting_timer: Timer = $Timer

@export_range(0.0, 100.0) var eruption_speed: float = 10

signal finished_eruption

var origin_position: Vector3
var top_position: Vector3
var hit: bool
var max_distance: float = 8.0
var velocity: Vector3 = Vector3.ZERO
var is_ready_to_erupt: bool
var is_ready_to_return: bool

func _ready() -> void:
	hide()
	origin_position = global_position

func _physics_process(delta: float) -> void:
	print(global_position, " ", origin_position)
	if is_ready_to_erupt:
		global_translate(velocity * delta)
		if global_position.distance_to(origin_position) > max_distance:
			is_ready_to_erupt = false
			velocity = Vector3(0, eruption_speed  * -1, 0)
			if not top_position:
				top_position = global_position
			resting_timer.start()
	if is_ready_to_return:
		global_translate(velocity * delta)
		if global_position.distance_to(top_position) > max_distance:
			is_ready_to_return = false
			hide()
			global_position = origin_position
			finished_eruption.emit(self)

func _on_body_entered(body: Node3D) -> void:
	if is_ready_to_erupt:
		pass#HIT ENEMY

func erupt():
	show()
	is_ready_to_erupt = true
	is_ready_to_return = false
	velocity = Vector3(0, eruption_speed, 0)

func _on_timer_timeout() -> void:
	is_ready_to_return = true

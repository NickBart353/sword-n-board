extends Node

var basic_data_timer: Timer

func _ready() -> void:
	basic_data_timer = Timer.new()
	basic_data_timer.autostart = true
	basic_data_timer.wait_time = 5
	if not basic_data_timer.timeout.is_connected(_basic_timer_timeout):
		basic_data_timer.timeout.connect(_basic_timer_timeout)
	add_child(basic_data_timer)

func _basic_timer_timeout() -> void:
	pass

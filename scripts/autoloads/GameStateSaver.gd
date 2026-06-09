extends Node

var basic_data_timer: Timer
var objects_to_persist: Array
var object_data: Dictionary = {}

func _ready() -> void:
	basic_data_timer = Timer.new()
	basic_data_timer.autostart = true
	basic_data_timer.wait_time = 5
	if not basic_data_timer.timeout.is_connected(_basic_timer_timeout):
		basic_data_timer.timeout.connect(_basic_timer_timeout)
	add_child(basic_data_timer)

func start():
	basic_data_timer.start()

func stop():
	basic_data_timer.stop()

func _basic_timer_timeout() -> void:
	objects_to_persist = get_tree().get_nodes_in_group("Persistant")
	for object in objects_to_persist:
		if object.data_changed:
			_save_data(object)

func _save_data(object: Object):
	var data: Dictionary = {}
	

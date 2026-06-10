extends Node

var basic_data_timer: Timer
var objects_to_persist: Array
var object_data: Dictionary = {}

var player: Player
var basic_player_data: BasicPlayerData
var advanced_player_data: AdvancedPlayerData

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
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
	_save_basic_player_data()

func _save_basic_player_data():
	basic_player_data.health = player.HEALTH
	basic_player_data.stamina = player.STAMINA
	basic_player_data.mana = player.MANA
	basic_player_data.position = player.global_position
	basic_player_data.rotation = player.global_rotation
	basic_player_data.spirit = 0
	DataManager.save_basic_player_data(basic_player_data)

func save_chests():
	objects_to_persist = get_tree().get_nodes_in_group("Persistant")
	for object in objects_to_persist:
		if object.data_changed:
			_save_data(object)

func _save_data(object: Object):
	var object_data_mapping: Dictionary = {}
	var data_dict: Dictionary = {}
	for data in object.data_to_save:
		data_dict[data.name]
	

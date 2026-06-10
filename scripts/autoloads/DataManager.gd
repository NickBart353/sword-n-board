extends Node

const save_path: String = "user://sword-n-board/data/"
const audio_file: String = "audio_settings.json"
const screen_data_file: String = "screen_settings.json"
const input_data_file: String = "input_settings.json"
const sensitivity_data_file: String = "sensitivity_settings.txt"
const shader_cache_information: String = "shader_cache_information.txt"

const basic_player_data_path: String = "player/basic_player_data.res"

func _ready() -> void:
	print(OS.get_data_dir())

func _check_base_dir() -> void:
	if not DirAccess.dir_exists_absolute(save_path):
		var error = DirAccess.make_dir_recursive_absolute(save_path)
		if error:
			print("Error while creating base directory at: ", save_path, "; Error: ", error)

func save_volume(volume_dict: Dictionary) -> bool:
	_check_base_dir()
	var full_path: String = "{0}{1}".format([save_path, audio_file])
	var file = FileAccess.open(full_path, FileAccess.WRITE)
	if file:
		var json_string = JSON.stringify(volume_dict)
		file.store_string(json_string)
	if FileAccess.get_open_error():
		return false
	else:
		return true

func load_volume() -> Dictionary:
	_check_base_dir()
	var full_path: String = "{0}{1}".format([save_path, audio_file])
	var file = FileAccess.open(full_path, FileAccess.READ)
	if file:
		var volume_data: Dictionary = JSON.parse_string(file.get_as_text())
		return volume_data
	else:
		return {}

func save_screen_settings(screen_dict: Dictionary) -> bool:
	_check_base_dir()
	var full_path: String = "{0}{1}".format([save_path, screen_data_file])
	var file = FileAccess.open(full_path, FileAccess.WRITE)
	if file:
		var json_string = JSON.stringify(screen_dict)
		file.store_string(json_string)
	if FileAccess.get_open_error():
		return false
	else:
		return true

func load_screen_settings() -> Dictionary:
	_check_base_dir()
	var full_path: String = "{0}{1}".format([save_path, screen_data_file])
	var file = FileAccess.open(full_path, FileAccess.READ)
	if file:
		var screen_data: Dictionary = JSON.parse_string(file.get_as_text())
		return screen_data
	else:
		return {}

func save_input_settings(input_dict: Dictionary) -> bool:
	_check_base_dir()
	var full_path: String = "{0}{1}".format([save_path, input_data_file])
	var file = FileAccess.open(full_path, FileAccess.WRITE)
	if file:
		var json_string = JSON.stringify(input_dict)
		file.store_string(json_string)
	if FileAccess.get_open_error():
		return false
	else:
		return true

func load_input_settings() -> Dictionary:
	_check_base_dir()
	var full_path: String = "{0}{1}".format([save_path, input_data_file])
	var file = FileAccess.open(full_path, FileAccess.READ)
	if file:
		var input_data: Dictionary = JSON.parse_string(file.get_as_text())
		return input_data
	else:
		return {}

func save_sensitivity(sensitivity: float):
	_check_base_dir()
	var full_path: String = "{0}{1}".format([save_path, sensitivity_data_file])
	var file = FileAccess.open(full_path, FileAccess.WRITE)
	if file:
		file.store_float(sensitivity)
	if FileAccess.get_open_error():
		return false
	else:
		return true

func load_sensitivity() -> float:
	_check_base_dir()
	var full_path: String = "{0}{1}".format([save_path, sensitivity_data_file])
	var file = FileAccess.open(full_path, FileAccess.READ)
	var sensitivity : float
	if file:
		#file.store_float(sensitivity)
		sensitivity = file.get_float()
	if FileAccess.get_open_error():
		return -1.0
	else:
		return sensitivity

func save_shader_cache_date() -> bool:
	_check_base_dir()
	var full_path: String = "{0}{1}".format([save_path, shader_cache_information])
	var file = FileAccess.open(full_path, FileAccess.WRITE)
	var shader_cache_date: String = Time.get_datetime_string_from_system()
	if file:
		file.store_string(shader_cache_date)
	if FileAccess.get_open_error():
		return false
	else:
		return true

func load_shader_cache_date() -> String:
	_check_base_dir()
	var full_path: String = "{0}{1}".format([save_path, shader_cache_information])
	var file = FileAccess.open(full_path, FileAccess.READ)
	if file:
		var shader_cache_date: String = file.get_as_text()
		return shader_cache_date
	else:
		return ""

func save_basic_player_data(basic_player_data: BasicPlayerData):
	var path: String = "{0}{1}".format([save_path,basic_player_data_path])
	_save_resource(basic_player_data, path)

func load_basic_player_data() -> BasicPlayerData:
	var path: String = "{0}{1}".format([save_path,basic_player_data_path])
	return _load_resource(path)

func _save_resource(resource: Resource, filepath: String):
	var error: Error = ResourceSaver.save(resource, filepath,ResourceSaver.FLAG_COMPRESS)
	if not error == Error.OK:
		push_error("Error while saving resource: ", resource.resource_name)

func _load_resource(filepath: String) -> Resource:
	if ResourceLoader.exists(filepath):
		return ResourceLoader.load(filepath)
	else:
		push_warning("No Basic Player Data found")
		return null

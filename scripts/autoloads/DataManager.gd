extends Node

const base_path: String = "user://sword-n-board/data/"
const audio_file: String = "audio_settings.txt"
const screen_data_file: String = "screen_settings.txt"
const input_data_file: String = "input_settings.txt"
const sensitivity_data_file: String = "sensitivity_settings.txt"
const shader_cache_information: String = "shader_cache_information.txt"

const chest_dir: String = "chests/"

const item_dir: String = "items/"
const equipment_data: String = "equipment.txt"

const player_dir: String = "player/"
const basic_player_data: String = "basic_player_data.res"
const advanced_player_data: String = "advanced_player_data.res"

func _ready() -> void:
	print(OS.get_data_dir())

func _check_base_dir(additional_path: String = "") -> void:
	var path: String = "{0}{1}".format([base_path, additional_path])
	if not DirAccess.dir_exists_absolute(path):
		var error = DirAccess.make_dir_recursive_absolute(path)
		if error:
			print("Error while creating base directory at: ", base_path, "; Error: ", error)

func save_volume(volume_dict: Dictionary) -> bool:
	_check_base_dir()
	var full_path: String = "{0}{1}".format([base_path, audio_file])
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
	var full_path: String = "{0}{1}".format([base_path, audio_file])
	var file = FileAccess.open(full_path, FileAccess.READ)
	if file:
		var volume_data: Dictionary = JSON.parse_string(file.get_as_text())
		return volume_data
	else:
		return {}

func save_screen_settings(screen_dict: Dictionary) -> bool:
	_check_base_dir()
	var full_path: String = "{0}{1}".format([base_path, screen_data_file])
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
	var full_path: String = "{0}{1}".format([base_path, screen_data_file])
	var file = FileAccess.open(full_path, FileAccess.READ)
	if file:
		var screen_data: Dictionary = JSON.parse_string(file.get_as_text())
		return screen_data
	else:
		return {}

func save_input_settings(input_dict: Dictionary) -> bool:
	_check_base_dir()
	var full_path: String = "{0}{1}".format([base_path, input_data_file])
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
	var full_path: String = "{0}{1}".format([base_path, input_data_file])
	var file = FileAccess.open(full_path, FileAccess.READ)
	if file:
		var input_data: Dictionary = JSON.parse_string(file.get_as_text())
		return input_data
	else:
		return {}

func save_sensitivity(sensitivity: float):
	_check_base_dir()
	var full_path: String = "{0}{1}".format([base_path, sensitivity_data_file])
	var file = FileAccess.open(full_path, FileAccess.WRITE)
	if file:
		file.store_float(sensitivity)
	if FileAccess.get_open_error():
		return false
	else:
		return true

func load_sensitivity() -> float:
	_check_base_dir()
	var full_path: String = "{0}{1}".format([base_path, sensitivity_data_file])
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
	var full_path: String = "{0}{1}".format([base_path, shader_cache_information])
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
	var full_path: String = "{0}{1}".format([base_path, shader_cache_information])
	var file = FileAccess.open(full_path, FileAccess.READ)
	if file:
		var shader_cache_date: String = file.get_as_text()
		return shader_cache_date
	else:
		return ""

func save_player_equipment(dictionary: Dictionary) -> int:
	var callable: Callable = Callable(self, "save_dictionary").bind(dictionary, equipment_data, item_dir)
	return WorkerThreadPool.add_task(callable)

func save_dictionary(item_dict: Dictionary, target_file_name: String, additional_dir: String = "") -> void:
	_check_base_dir(additional_dir)
	var full_path: String = "{0}{1}{2}".format([base_path, additional_dir, target_file_name])
	var file: FileAccess = FileAccess.open(full_path, FileAccess.WRITE)
	if file:
		file.store_var(item_dict)
	if FileAccess.get_open_error():
		push_error("Error while saving items: ", item_dict)

func load_dictionary(file_path: String, additional_dir: String = "") -> Dictionary:
	_check_base_dir(additional_dir)
	var full_path: String = "{0}{1}{2}".format([base_path, additional_dir, file_path])
	var file: FileAccess = FileAccess.open(full_path, FileAccess.READ)
	var item_dict: Dictionary
	if file:
		item_dict = file.get_var()
	return item_dict

func save_basic_player_data(resource: BasicPlayerData):
	var callable: Callable = Callable(self, "_atomic_resource_save").bind(resource, basic_player_data, player_dir)
	WorkerThreadPool.add_task(callable)

func save_advanced_player_data(resource: AdvancedPlayerData):
	var callable: Callable = Callable(self, "_atomic_resource_save").bind(resource, advanced_player_data, player_dir)
	WorkerThreadPool.add_task(callable)

func _atomic_resource_save(resource: Resource, resource_name: String, additional_dir: String):
	_check_base_dir(additional_dir)
	var temp_resource_path: String = "{0}{1}temp_{2}".format([base_path, additional_dir, resource_name])
	if _save_resource(resource, temp_resource_path) == Error.OK:
		var directory_path: String = "{0}{1}".format([base_path, additional_dir])
		_rename_resource(resource_name, directory_path)

func _save_resource(resource: Resource, filepath: String):
	var error: Error = ResourceSaver.save(resource, filepath)
	if not error == Error.OK:
		push_error("Error while saving resource: ", resource.resource_name)
	return error

func _rename_resource(resource_name: String, directory_path: String):
	var dir: DirAccess = DirAccess.open(directory_path)
	var temp_resource_name: String = "temp_{0}".format([resource_name])
	var save_resource_name: String = "save_{0}".format([resource_name])
	var backup_resource_name: String = "backup_{0}".format([resource_name])
	if ResourceLoader.exists("{0}{1}".format([directory_path, save_resource_name])):
		dir.rename(save_resource_name, backup_resource_name)
	if ResourceLoader.exists("{0}{1}".format([directory_path, temp_resource_name])):
		dir.rename(temp_resource_name, save_resource_name)

func load_basic_player_data() -> BasicPlayerData:
	_check_base_dir(player_dir)
	var path: String = "{0}{1}save_{2}".format([base_path, player_dir, basic_player_data])
	return _load_resource(path)

func _load_resource(filepath: String) -> Resource:
	if ResourceLoader.exists(filepath):
		return ResourceLoader.load(filepath)
	else:
		push_warning("No Basic Player Data found")
		return null

func update_chests(chest_dict: Dictionary) -> int:
	var callable: Callable = Callable(self, "update_chests_multi_threaded").bind(chest_dict)
	return WorkerThreadPool.add_task(callable)

func update_chests_multi_threaded(chest_dict: Dictionary):
	_check_base_dir(chest_dir)
	var chest_directory: String = "{0}{1}".format([base_path, chest_dir])
	for chest_id in chest_dict:
		var chest_file: FileAccess = FileAccess.open("{0}{1}.txt".format([chest_directory, chest_id]), FileAccess.WRITE) 
		chest_file.store_var(chest_dict[chest_id])

func load_chests() -> Dictionary:
	_check_base_dir(chest_dir)
	var chest_directory: DirAccess = DirAccess.open("{0}{1}".format([base_path, chest_dir]))
	var chest_filenames: PackedStringArray = chest_directory.get_files()
	if chest_filenames.is_empty():
		return {}
	var chest_dictionary: Dictionary = {}
	for filename: String in chest_filenames:
		var chest_file: FileAccess = FileAccess.open("{0}{1}{2}".format([base_path, chest_dir, filename]), FileAccess.READ)
		chest_dictionary[filename.left(-4)] = chest_file.get_var()
	return chest_dictionary

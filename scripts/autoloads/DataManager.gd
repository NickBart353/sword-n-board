extends Node

const base_path: String = "user://data/"
const base_tree_path: String = "res://"

const audio_file: String = "audio_settings.txt"
const screen_data_file: String = "screen_settings.txt"
const input_data_file: String = "input_settings.txt"
const sensitivity_data_file: String = "sensitivity_settings.txt"
const shader_cache_information: String = "shader_cache_information.txt"

const save_file_path: String = "savefiles/"
const save_file_metada: String = "{0}.tres"

const mobspawn_dir: String = "mobspawns/"
const mobspawn_data: String = "mobspawns.tres"

const chest_dir: String = "chests/"

const item_dir: String = "items/"
const equipment_data: String = "equipment.txt"
const player_item_data: String = "player_items.txt"

const db_path: String = "db/"
const item_db_path: String = "item_db.db"
const item_db_path_backup: String = "item_db_backup.db"

const player_dir: String = "player/"
const basic_player_data: String = "basic_player_data.tres"
const advanced_player_data: String = "advanced_player_data.tres"

const item_table_name: String = "items"
const item_table_dict: Dictionary = {
	"id":{"data_type":"int", "primary_key": true, "not_null": true, "auto_increment": true},
	"item_id": {"data_type":"text", "not_null": true},
	"quantity": {"data_type":"int", "not_null": true},
	"equipped": {"data_type": "int", "not_null": false},
	"upgrade_level": {"data_type": "int", "not_null": false},
	"upgrade_type": {"data_type": "int", "not_null": false},
	"storage_id": {"data_type": "text", "not_null": false},
}

var item_db: SQLite = SQLite.new()

var current_save_file_id: String

var current_mob_path_dir: String
var current_player_path_dir: String
var current_item_path_dir: String
var current_chest_path_dir: String

func _ready() -> void:
	print(OS.get_data_dir())

func connect_db() -> void:
	item_db = SQLite.new()
	item_db.path = "{0}{1}{2}_{3}".format([base_tree_path, db_path, current_save_file_id, item_db_path])
	item_db.verbosity_level = SQLite.QUIET
	item_db.open_db()
	
	item_db.query_with_bindings("SELECT * FROM sqlite_master WHERE type='table' AND name=?;", [item_table_name])
	if item_db.query_result.is_empty():
		item_db.create_table(item_table_name, item_table_dict)


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
	var callable: Callable = Callable(self, "save_dictionary").bind(dictionary, equipment_data, current_item_path_dir)
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
	var callable: Callable = Callable(self, "_atomic_resource_save").bind(resource, basic_player_data, current_player_path_dir)
	WorkerThreadPool.add_task(callable)

func save_advanced_player_data(resource: AdvancedPlayerData):
	var callable: Callable = Callable(self, "_atomic_resource_save").bind(resource, advanced_player_data, current_player_path_dir)
	WorkerThreadPool.add_task(callable)

func save_mobspawns(resource: MobSpawnResource):
	var callable: Callable = Callable(self, "_atomic_resource_save").bind(resource, mobspawn_data, current_mob_path_dir)
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
	_check_base_dir(current_player_path_dir)
	var path: String = "{0}{1}save_{2}".format([base_path, current_player_path_dir, basic_player_data])
	return _load_resource(path)

func load_mobspawn_data() -> MobSpawnResource:
	_check_base_dir(current_mob_path_dir)
	var path: String = "{0}{1}save_{2}".format([base_path, current_mob_path_dir, mobspawn_data])
	return _load_resource(path)

func _load_resource(filepath: String) -> Resource:
	if ResourceLoader.exists(filepath):
		return ResourceLoader.load(filepath)
	else:
		push_warning("No Data found in: ", filepath)
		return null

func load_player_items() -> Array:
	#Arrayselect_rows(table_name: String, conditions: String, columns: Array)
	return item_db.select_rows(item_table_name, "storage_id is NULL", ["id", "item_id", "quantity", "equipped", "upgrade_level", "upgrade_type"])
	#_check_base_dir(player_dir)
	#return load_dictionary(player_item_data, player_dir)

#func update_chests(chest_dict: Dictionary) -> int:
	#var callable: Callable = Callable(self, "update_chests_multi_threaded").bind(chest_dict)
	#return WorkerThreadPool.add_task(callable)

func _update_chest_and_items_multithreaded(player_dict: Dictionary, chest_dict: Dictionary) -> void:
	save_dictionary(player_dict, player_item_data, current_player_path_dir)
	update_chests_multi_threaded(chest_dict)

func update_chests_multi_threaded(chest_dict: Dictionary):
	_check_base_dir(current_chest_path_dir)
	var chest_directory: String = "{0}{1}".format([base_path, current_chest_path_dir])
	for chest_id in chest_dict:
		var chest_file: FileAccess = FileAccess.open("{0}{1}.txt".format([chest_directory, chest_id]), FileAccess.WRITE) 
		chest_file.store_var(chest_dict[chest_id])

#func load_chests() -> Dictionary:
	#_check_base_dir(chest_dir)
	#var chest_directory: DirAccess = DirAccess.open("{0}{1}".format([base_path, chest_dir]))
	#var chest_filenames: PackedStringArray = chest_directory.get_files()
	#if chest_filenames.is_empty():
		#return {}
	#var chest_dictionary: Dictionary = {}
	#for filename: String in chest_filenames:
		#var chest_file: FileAccess = FileAccess.open("{0}{1}{2}".format([base_path, chest_dir, filename]), FileAccess.READ)
		#chest_dictionary[filename.left(-4)] = chest_file.get_var()
	#return chest_dictionary

func update_chest_and_items(prepared_item_list: Array) -> int:
	var callable: Callable = Callable(self, "_save_items_to_db").bind(prepared_item_list.duplicate(true))
	return WorkerThreadPool.add_task(callable)

func _save_items_to_db(prepared_item_list: Array):
	item_db.backup_to("{0}{1}{2}_{3}".format([base_tree_path, db_path, current_save_file_id, item_db_path_backup]))
	item_db.query("DELETE FROM {0};".format([item_table_name]))
	item_db.insert_rows(item_table_name, prepared_item_list)

func create_new_savefile(savefile_metadata: SaveFileMetadata):
	var filepath: String = "{0}{1}/".format([save_file_path, savefile_metadata.savefile_id])
	_check_base_dir(filepath)
	var save_path: String = "{0}{1}/{2}.tres".format([base_path, filepath, savefile_metadata.savefile_id])
	ResourceSaver.save(savefile_metadata, save_path)
	#_atomic_resource_save(savefile_metadata, filepath, save_file_metada.format([savefile_metadata.savefile_id]))
	current_save_file_id = savefile_metadata.savefile_id
	
	current_mob_path_dir = "{0}{1}".format([filepath, mobspawn_dir])
	current_player_path_dir = "{0}{1}".format([filepath, player_dir])
	current_item_path_dir = "{0}{1}".format([filepath, item_dir])
	current_chest_path_dir = "{0}{1}".format([filepath, chest_dir])
	
	print(current_mob_path_dir)
	print(current_player_path_dir)
	print(current_item_path_dir)
	print(current_chest_path_dir)

func load_savefiles() -> Array:
	_check_base_dir(save_file_path)
	var resource_array: Array = []
	var savefile_dir: DirAccess = DirAccess.open("{0}{1}".format([base_path, save_file_path]))
	for savefile in savefile_dir.get_directories():
		resource_array.append(_load_resource("{0}{1}{2}/{3}.tres".format([base_path, save_file_path, savefile, savefile])))
	
	return resource_array

func delete_savefile(id: String) -> bool:
	_check_base_dir(save_file_path)
	var savefile_dir: DirAccess = DirAccess.open("{0}{1}".format([base_path, save_file_path]))
	for savefile in savefile_dir.get_directories():
		if savefile == id:
			_delete_folder_resursive("{0}{1}{2}/".format([base_path, save_file_path,savefile]))
			savefile_dir.remove(id)
			return true
	return false

func _delete_folder_resursive(path: String):
	var savefile_dir: DirAccess = DirAccess.open(path)
	for file in savefile_dir.get_files():
		savefile_dir.remove(file)
	for folder in savefile_dir.get_directories():
		_delete_folder_resursive("{0}{1}".format([path,folder]))
	savefile_dir.remove(path)

func set_savefile_id(id: String):
	current_save_file_id = id

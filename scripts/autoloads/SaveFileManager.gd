extends Node

signal new_savefile_loaded

const user_path: String = "user://"

const savefile_path: String = "savefiles/"
const savefile_name: String = "savefile.tres"
const temp_resource_name: String = "temp_savefile.tres"
const save_resource_name: String = "save_savefile.tres"
const backup_resource_name: String = "backup_savefile.tres"

const last_savefile_path: String = "user://savefiles/last_savefile_id.tres"
const last_savefile_name: String = "last_savefile_id.tres"

var savefile_folder_path: String
var path_to_savefile: String

var current_savefile_id: String

func _ready() -> void:
	savefile_folder_path = "{0}{1}".format([user_path, savefile_path])
	current_savefile_id = load_last_savefile_id()

func load_last_savefile_id() -> String:
	var savefile: LastSaveFile
	var user_dir: DirAccess = DirAccess.open(user_path)
	
	if not user_dir.dir_exists(savefile_path):
		DirAccess.make_dir_recursive_absolute(savefile_folder_path)
		return ""
	
	if ResourceLoader.exists(last_savefile_path):
		savefile = ResourceLoader.load(last_savefile_path) as LastSaveFile
		current_savefile_id = savefile.last_savefile_id
		return current_savefile_id
	
	return ""

func set_savefile_id(new_savefile_last_savefile_id: String):
	var new_savefile_last_savefile: LastSaveFile = LastSaveFile.new()
	new_savefile_last_savefile.last_savefile_id = new_savefile_last_savefile_id
	
	var error: Error = ResourceSaver.save(new_savefile_last_savefile, last_savefile_path)
	current_savefile_id = new_savefile_last_savefile.last_savefile_id
	new_savefile_loaded.emit(current_savefile_id)
	if not error == Error.OK:
		push_error("Error while saving last filepath resource")
	return error

func create_savefile(resource: SaveFile):
	var savefile_folder: DirAccess = DirAccess.open(savefile_folder_path)
	if not savefile_folder.dir_exists(resource.savefile_id):
		savefile_folder.make_dir(resource.savefile_id)
	path_to_savefile = "{0}{1}/".format([savefile_folder_path, resource.savefile_id])
	_atomic_resource_save(resource, path_to_savefile, savefile_name)

func load_savefile(savefile_id: String) -> SaveFile:
	print("loading: ", current_savefile_id)
	var user_dir: DirAccess = DirAccess.open(savefile_folder_path)
	if user_dir.get_directories().has(savefile_id):
		path_to_savefile = "{0}{1}/".format([savefile_folder_path, savefile_id])
		return get_savefile_from_id(savefile_id)
	return null

func load_all_savefiles() -> Array:
	var resource_array: Array = []
	var savefile_folder_dir: DirAccess = DirAccess.open(savefile_folder_path)
	
	for directory in savefile_folder_dir.get_directories():
		resource_array.append(get_savefile_from_id(directory))
	
	return resource_array

func get_savefile_from_id(resource_id: String) -> SaveFile:
	var savefile_dir: DirAccess = DirAccess.open("{0}{1}".format([savefile_folder_path, resource_id]))
	if savefile_dir.file_exists(save_resource_name):
		var filepath: String = "{0}{1}/{2}".format([savefile_folder_path, resource_id, save_resource_name])
		push_warning("filepath: ", filepath)
		return ResourceLoader.load(filepath)
	if savefile_dir.file_exists(backup_resource_name):
		var filepath: String = "{0}{1}/{2}".format([savefile_folder_path, resource_id, backup_resource_name])
		push_error("did not find save resource: ", resource_id, " had to load backup instead")
		return ResourceLoader.load(filepath)
	push_error("did not find resource: ", resource_id)
	return null

func delete_savefile_from_id(savefile_id: String) -> void:
	print("deleting: ", savefile_id)
	pass

func save_game(resource: SaveFile):
	var callable: Callable = Callable(self, "_atomic_resource_save").bind(resource, path_to_savefile, savefile_name)
	return WorkerThreadPool.add_task(callable)

func _atomic_resource_save(resource: Resource, path_to_file: String, resource_name: String):
	if _save_resource(resource, path_to_file, resource_name) == Error.OK:
		_rename_resource(path_to_file, resource_name)

func _save_resource(resource: Resource, path_to_file: String, resource_name: String):
	var temp_filepath: String = "{0}temp_{1}".format([path_to_file, resource_name])
	var error: Error = ResourceSaver.save(resource, temp_filepath)
	if not error == Error.OK:
		push_error("Error while saving resource: ", resource_name, " at: ", path_to_savefile)
	return error

func _rename_resource(path_to_file: String, resource_name: String):
	var dir: DirAccess = DirAccess.open(path_to_file)
	if ResourceLoader.exists("{0}{1}".format([path_to_file, save_resource_name])):
		dir.rename(save_resource_name, backup_resource_name)
	if ResourceLoader.exists("{0}{1}".format([path_to_file, temp_resource_name])):
		dir.rename(temp_resource_name, save_resource_name)

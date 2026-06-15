extends Node

const user_path: String = "user://"
const savefile_path: String = "savefiles/"
const savefile_name: String = "savefile.tres"

const last_savefile_path: String = "user://savefiles/last_save_id.tres"

var savefile_folder_path: String
var path_to_savefile: String

var current_savefile_id: String

func _ready() -> void:
	savefile_folder_path = "{0}{1}".format([user_path, savefile_path])
	var savefile: LastSaveFile
	var user_dir: DirAccess = DirAccess.open(user_path)
	
	if not user_dir.dir_exists(savefile_path):
		DirAccess.make_dir_recursive_absolute(savefile_folder_path)
		return # END
	
	if ResourceLoader.exists(last_savefile_path):
		savefile = ResourceLoader.load(last_savefile_path) as LastSaveFile
	
	current_savefile_id = savefile.last_savefile_id

func create_savefile(resource: SaveFile):
	var savefile_folder: DirAccess = DirAccess.open(savefile_folder_path)
	if not savefile_folder.dir_exists(resource.save_id):
		savefile_folder.make_dir(resource.save_id)
	path_to_savefile = "{0}{1}/".format([savefile_folder_path, resource.save_id])
	_atomic_resource_save(resource, path_to_savefile, savefile_name)

func load_savefile():
	pass

func delete_savefile():
	pass

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
	var temp_resource_name: String = "temp_{0}".format([resource_name])
	var save_resource_name: String = "save_{0}".format([resource_name])
	var backup_resource_name: String = "backup_{0}".format([resource_name])
	if ResourceLoader.exists("{0}{1}".format([path_to_file, save_resource_name])):
		dir.rename(save_resource_name, backup_resource_name)
	if ResourceLoader.exists("{0}{1}".format([path_to_file, temp_resource_name])):
		dir.rename(temp_resource_name, save_resource_name)

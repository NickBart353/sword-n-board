extends Node

const save_path: String = "user://"
const audio_file: String = "audio_settings.json"

func save_volume(volume_dict: Dictionary) -> bool:
	var full_path: String = "{0}{1}".format([save_path, audio_file])
	print(full_path)
	var file = FileAccess.open(full_path, FileAccess.WRITE)
	if file:
		var json_string = JSON.stringify(volume_dict)
		file.store_string(json_string)
	if FileAccess.get_open_error():
		return false
	else:
		return true

func load_volume() -> Dictionary:
	var full_path: String = "{0}{1}".format([save_path, audio_file])
	if FileAccess.file_exists(full_path):
		var file = FileAccess.open(full_path, FileAccess.READ)
		var volume_data: Dictionary = JSON.parse_string(file.get_as_text())
		return volume_data
	else:
		return {}

class_name SaveFileScreen extends VBoxContainer

signal savefile_screen_closed
signal savefile_selected
signal savefile_deleted

@onready var save_file_container: HBoxContainer = $ScrollContainer/SaveFileContainer

@export var save_file_scene: PackedScene

func set_savefiles(resource_array: Array):
	resource_array.sort_custom(_sort_by_last_played_date)
	for savefile_metadata in resource_array:
		if savefile_metadata == null:
			continue
		var save_file: SaveFileSelector = save_file_scene.instantiate()
		save_file_container.add_child(save_file)
		
		save_file.set_data(savefile_metadata.character_name, 
		"", #LEVEL 
		savefile_metadata.creation_date, 
		savefile_metadata.last_played_date, 
		savefile_metadata.savefile_id)
		
		save_file.delete_savefile.connect(_delete_savefile)
		save_file.selected.connect(_selected_file)

func _sort_by_last_played_date(a: SaveFile, b: SaveFile) -> bool:
	return a.last_played_date > b.last_played_date

func reset_savefiles():
	for savefile in save_file_container.get_children():
		savefile.queue_free()

func _delete_savefile(id: String):
	savefile_deleted.emit(id)

func _selected_file(id: String):
	savefile_selected.emit(id)

func _on_back_button_pressed() -> void:
	savefile_screen_closed.emit()

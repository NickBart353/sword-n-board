extends VBoxContainer

signal savefile_screen_closed
signal savefile_selected
signal savefile_deleted

@onready var save_file_container: HBoxContainer = $PanelContainer/ScrollContainer/SaveFileContainer

@export var save_file_scene: PackedScene

func set_savefiles(resource_array: Array):
	for savefile_metadata in resource_array:
		var save_file: SaveFile = save_file_scene.instantiate()
		save_file_container.add_child(save_file)
		save_file.age_value_label.text = savefile_metadata.creation_date
		save_file.savefile_id = savefile_metadata.savefile_id
		save_file.save_file_name.text = savefile_metadata.character_name
		save_file.delete_savefile.connect(_delete_savefile)
		save_file.selected.connect(_selected_file)

func reset_savefiles():
	for savefile in save_file_container.get_children():
		savefile.queue_free()

func _delete_savefile(id: String):
	savefile_deleted.emit(id)

func _selected_file(id: String):
	savefile_selected.emit(id)

func _on_back_button_pressed() -> void:
	savefile_screen_closed.emit()

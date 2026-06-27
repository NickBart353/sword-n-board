class_name SaveFileSelector extends PanelContainer

signal selected
signal delete_savefile

var delete_focused: bool = false
var savefile_id: String

@onready var save_file_name: Label = $PanelContainer/VBoxContainer/MarginContainer/VBoxContainer/SaveFileName
@onready var level_value_label: Label = $PanelContainer/VBoxContainer/MarginContainer/VBoxContainer/DataContainer/GridContainer/LevelValueLabel
@onready var age_value_label: Label = $PanelContainer/VBoxContainer/MarginContainer/VBoxContainer/DataContainer/GridContainer/AgeValueLabel
@onready var progress_bar: ProgressBar = $PanelContainer/Container/ProgressBar
@onready var last_played_value: Label = $PanelContainer/VBoxContainer/MarginContainer/VBoxContainer/DataContainer/GridContainer/LastPlayedValue

@export_range(0.0, 1000.0) var fill_speed: float = 50.0

func set_data(character_name: String, level: String, created_date: String, last_played_date: String, id: String):
	save_file_name.text = character_name
	level_value_label.text = level
	age_value_label.text = created_date
	last_played_value.text = last_played_date
	savefile_id = id

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if delete_focused:
		progress_bar.value += fill_speed * delta
	else:
		progress_bar.value -= fill_speed * delta

func _on_delete_hover_button_mouse_entered() -> void:
	delete_focused = true

func _on_delete_hover_button_mouse_exited() -> void:
	delete_focused = false

func _on_delete_hover_button_pressed() -> void:
	if progress_bar.value == progress_bar.max_value:
		delete_savefile.emit(savefile_id)

func _on_select_save_file_button_pressed() -> void:
	selected.emit(savefile_id)


func _on_select_save_file_button_mouse_entered() -> void:
	pass#$PanelContainer/VBoxContainer/SelectSaveFileButton


func _on_select_save_file_button_mouse_exited() -> void:
	pass # Replace with function body.

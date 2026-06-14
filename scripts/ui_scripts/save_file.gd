extends PanelContainer

signal selected
signal delete_savefile

var delete_focused: bool = false

@onready var save_file_name: Label = $PanelContainer/VBoxContainer/VBoxContainer/SaveFileName
@onready var level_value_label: Label = $PanelContainer/VBoxContainer/VBoxContainer/DataContainer/GridContainer/LevelValueLabel
@onready var age_value_label: Label = $PanelContainer/VBoxContainer/VBoxContainer/DataContainer/GridContainer/AgeValueLabel
@onready var progress_bar: ProgressBar = $PanelContainer/Container/ProgressBar

@export_range(0.0, 1000.0) var fill_speed: float = 50.0

func set_data(character_name: String, level: String, created_date: String):
	save_file_name.text = character_name
	level_value_label.text = level
	age_value_label.text = created_date

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if delete_focused:
		progress_bar.value += fill_speed * delta
	else:
		progress_bar.value -= fill_speed * delta

func _on_select_save_file_button_button_down() -> void:
	selected.emit()

func _on_delete_hover_button_button_down() -> void:
	if progress_bar.value == progress_bar.max_value:
		delete_savefile.emit()
		print("tst")

func _on_delete_hover_button_mouse_entered() -> void:
	delete_focused = true

func _on_delete_hover_button_mouse_exited() -> void:
	delete_focused = false

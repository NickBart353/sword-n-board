extends PanelContainer

signal new_save

func _on_new_save_button_pressed() -> void:
	new_save.emit()

extends PanelContainer

signal close_settings
signal done_checking

#settings
@onready var audio: GridContainer = $SettingsOrganizer/SettingsContainer/SettingTabs/Audio/Audio
@onready var display: GridContainer = $SettingsOrganizer/SettingsContainer/SettingTabs/Display/Display
@onready var input: VBoxContainer = $SettingsOrganizer/SettingsContainer/SettingTabs/Input/ScrollContainer/Input

#unsaved-changes
@onready var unsaved_settings_popup: PanelContainer = $UnsavedSettingsPopup

#keybind
@onready var keybind_popup: PanelContainer = $KeybindPopup
@onready var keybind_label: Label = $KeybindPopup/_/KeybindLabel

#already-bound
@onready var already_bound_key_popup: PanelContainer = $AlreadyBoundKeyPopup
@onready var already_bound_label: Label = $AlreadyBoundKeyPopup/_/AlreadyBoundLabel
@onready var keep_new_bind_button: Button = $AlreadyBoundKeyPopup/_/_/KeepNewBindButton
@onready var cancel_button: Button = $AlreadyBoundKeyPopup/_/_/CancelButton

var save_list: Array[Control]
var save_counter: int
var checking: bool

func load_settings():
	audio.load_settings()
	display.load_settings()
	input.load_settings()

func check_for_unsaved_settings():
	audio._on_back_button_pressed()
	display._on_back_button_pressed()
	input._on_back_button_pressed()
	checking = true

func _ready() -> void:
	hide()
	unsaved_settings_popup.hide()
	keybind_popup.hide()
	already_bound_key_popup.hide()
	
	save_counter = 0
	
	input.saved_settings.connect(_saved_settings)
	input.unsaved_settings.connect(_unsaved_settings)
	input.show_keybind_popup.connect(_show_keybind_popup)
	input.show_existing_keybind_popup.connect(_show_existing_keybind_popup)
	input.hide_keybind_popup.connect(_hide_keybind_popup)
	input.hide_existing_keybind_popup.connect(_hide_existing_keybind_popup)
	input.update_keybind_text.connect(_update_keybind_text)
	
	audio.saved_settings.connect(_saved_settings)
	display.saved_settings.connect(_saved_settings)
	
	audio.unsaved_settings.connect(_unsaved_settings)
	display.unsaved_settings.connect(_unsaved_settings)

func _process(_delta: float) -> void:
	if save_list:
		unsaved_settings_popup.show()
	if save_counter >= 3:
		close_settings.emit()
		save_counter = 0

func _unsaved_settings(setting: Control):
	save_list.append(setting)

func _saved_settings():
	save_counter += 1

func _show_keybind_popup() -> void:
	keybind_popup.show()
	keybind_label.text = "..."

func _hide_keybind_popup() -> void:
	keybind_popup.hide()

func _show_existing_keybind_popup(label_text: String) -> void:
	already_bound_key_popup.show()
	already_bound_label.text = label_text

func _hide_existing_keybind_popup() -> void:
	already_bound_key_popup.hide()

func _update_keybind_text(new_keybind_text: String) -> void:
	keybind_label.text = new_keybind_text

func _on_cancel_unchanged_button_pressed() -> void:
	for setting in save_list:
		setting.reset_current_to_saved()
	save_counter = 0
	save_list.clear()
	#close_settings.emit()
	unsaved_settings_popup.hide()
	if checking:
		checking = false
		#close_settings.emit()
		done_checking.emit()
	else:
		close_settings.emit()

func _on_save_unchanged_button_pressed() -> void:
	for setting in save_list:
		setting._on_save_button_pressed()
	save_counter = 0
	save_list.clear()
	unsaved_settings_popup.hide()
	if checking:
		checking = false
		#close_settings.emit()
		done_checking.emit()
	else:
		close_settings.emit()

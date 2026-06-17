extends CanvasLayer

signal game_started

@export var main_game_scene: String = &""

@export_group("Audio")
@export var button_hover_sound: AudioStream
@export var button_click_sound: AudioStream
@export var start_button_click_sound: AudioStream

@onready var main_menu_button_container: PanelContainer = $MainMenuButtonContainer
@onready var settings_menu: PanelContainer = $SettingsMenu
@onready var save_file_screen: SaveFileScreen = $SaveFileScreen
@onready var new_game_screen: NewGameScreen = $NewGameScreen

func load_data():
	settings_menu.load_settings()

func _ready() -> void:
	$MainMenuButtonContainer/VBoxContainer/LoadGame.hide()
	$MainMenuButtonContainer/VBoxContainer/StartGame.hide()
	$MainMenuButtonContainer/VBoxContainer/StartGame.hide()
	$MainMenuButtonContainer/VBoxContainer/LoadGame.hide()
	
	_load_savefiles()
	
	for child in self.find_children("*", "Control", true, false):
		if child is Button and child.disabled == false:
			if not child.mouse_entered.is_connected(_play_hover_sound):
				child.mouse_entered.connect(_play_hover_sound)
			if not child.pressed.is_connected(_play_click_sound):
				child.pressed.connect(_play_click_sound)
	if not $MainMenuButtonContainer/VBoxContainer/StartGame.pressed.is_connected(_pressed_start_button):
		$MainMenuButtonContainer/VBoxContainer/StartGame.pressed.connect(_pressed_start_button)

func _load_savefiles():
	var last_file_id: String = SaveFileManager.load_last_savefile_id()
	
	var savefiles: Array = SaveFileManager.load_all_savefiles() #DataManager.load_savefiles()
	print(savefiles)
	print(savefiles.is_empty())
	if savefiles.is_empty():
		$MainMenuButtonContainer/VBoxContainer/LoadGame.hide()
		$MainMenuButtonContainer/VBoxContainer/StartGame.hide()
	else:
		$MainMenuButtonContainer/VBoxContainer/LoadGame.show()
		if last_file_id != "":
			$MainMenuButtonContainer/VBoxContainer/StartGame.show()
	
	save_file_screen.reset_savefiles()
	save_file_screen.set_savefiles(savefiles)

func _play_hover_sound():
	AudioManager.player_ui_sfx(button_hover_sound)

func _play_click_sound():
	AudioManager.player_ui_sfx(button_click_sound)

func _pressed_start_button():
	AudioManager.player_ui_sfx(start_button_click_sound)
	game_started.emit()

func _on_start_game_pressed() -> void:
	SceneLoader.load_scene(main_game_scene)

func _on_settings_pressed() -> void:
	main_menu_button_container.hide()
	settings_menu.show()

func _on_credits_pressed() -> void:
	pass # Show all credits

func _on_exit_game_pressed() -> void:
	get_tree().quit()

func _on_settings_menu_close_settings() -> void:
	main_menu_button_container.show()
	settings_menu.hide()

func _on_load_game_pressed() -> void:
	save_file_screen.show()
	main_menu_button_container.hide()

func _on_new_game_pressed() -> void:
	new_game_screen.show()
	main_menu_button_container.hide()

func _on_new_game_screen_create_new_game(character_name: String) -> void:
	#var savefile_metadata: SaveFileMetadata = SaveFileMetadata.new()
	#savefile_metadata.savefile_id = UuidGenerator.uuid4()
	#savefile_metadata.character_name = character_name
	#savefile_metadata.creation_date = Time.get_date_string_from_system()
	var new_savefile: SaveFile = SaveFile.new()
	new_savefile.savefile_id = UuidGenerator.uuid4()
	new_savefile.character_name = character_name
	new_savefile.creation_date = Time.get_date_string_from_system()
	#DataManager.create_new_savefile(savefile_metadata)
	SaveFileManager.create_savefile(new_savefile)
	SaveFileManager.set_savefile_id(new_savefile.savefile_id)
	SceneLoader.load_scene(main_game_scene)

func _on_new_game_screen_new_game_screen_closed() -> void:
	main_menu_button_container.show()
	new_game_screen.hide()

func _on_save_file_screen_savefile_screen_closed() -> void:
	main_menu_button_container.show()
	save_file_screen.hide()

func _on_save_file_screen_savefile_selected(id: String) -> void:
	#DataManager.set_savefile_id(id)
	SaveFileManager.set_savefile_id(id)
	SceneLoader.load_scene(main_game_scene)

func _on_save_file_screen_savefile_deleted(id: String) -> void:
	print("delete: ", DataManager.delete_savefile(id))
	_load_savefiles()

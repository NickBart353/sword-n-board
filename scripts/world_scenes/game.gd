extends Main

@export var main_menu_scene: String = &""

@onready var game_menus: CanvasLayer = $GameMenus

func _ready() -> void:
	super()
	game_menus.load_data()

func _on_game_menus_return_to_main_menu() -> void:
	LoopMixer.stop_looping()
	GameStateSaver.stop()
	SceneLoader.load_scene(main_menu_scene)

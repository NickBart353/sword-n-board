extends Main

@onready var game_menus: CanvasLayer = $GameMenus

func _ready() -> void:
	super()
	game_menus.load_data()

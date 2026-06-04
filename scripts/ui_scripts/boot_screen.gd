extends Control

@onready var shader_cache_loading_screen: PanelContainer = $ShaderCacheLoadingScreen
@onready var godot_screen: PanelContainer = $GodotScreen
@onready var company_screen: PanelContainer = $CompanyScreen

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var main_menu_path: String = "res://scenes/main_scenes/main_menu.tscn"

func _ready() -> void:
	shader_cache_loading_screen.start()
	animation_player.play("bootscreen/shadercache_fadein")

func _on_shader_cache_loading_screen_cache_loaded() -> void:
	animation_player.play("bootscreen/shadercache_fadeout")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"bootscreen/shadercache_fadeout":
			animation_player.play("bootscreen/godot")
		"bootscreen/godot":
			animation_player.play("bootscreen/company")
		"bootscreen/company":
			SceneLoader.load_scene(main_menu_path)

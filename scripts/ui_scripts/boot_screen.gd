extends Control

@onready var shader_cache_loading_screen: PanelContainer = $ShaderCacheLoadingScreen
@onready var godot_screen: PanelContainer = $GodotScreen
@onready var company_screen: PanelContainer = $CompanyScreen

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var main_menu_path: String = "res://scenes/main_scenes/main_menu.tscn"
var need_to_load_shaders: bool

func _ready() -> void:
	#DEBUG: somefunc
	need_to_load_shaders = _check_shader_cache()
	#DEBUG END
	if need_to_load_shaders:
		shader_cache_loading_screen.start()
		animation_player.play("bootscreen/shadercache_fadein")
	else:
		shader_cache_loading_screen.hide()
		animation_player.play("bootscreen/godot")

func _check_shader_cache() -> bool:
	var last_shader_load_date: String = DataManager.load_shader_cache_date()
	
	if not last_shader_load_date:
		return true
	
	var unix_last_shader_load_date = Time.get_unix_time_from_datetime_string(last_shader_load_date)
	
	if _was_shader_loaded_today(unix_last_shader_load_date):
		return false
	
	return true

func _was_shader_loaded_today(unix_date: int) -> bool:
	return (unix_date - Time.get_unix_time_from_datetime_string(Time.get_datetime_string_from_system(false))) < 86400

func _on_shader_cache_loading_screen_cache_loaded() -> void:
	DataManager.save_shader_cache_date()
	animation_player.play("bootscreen/shadercache_fadeout")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"bootscreen/shadercache_fadeout":
			animation_player.play("bootscreen/godot")
		"bootscreen/godot":
			animation_player.play("bootscreen/company")
		"bootscreen/company":
			SceneLoader.load_scene(main_menu_path)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			match animation_player.current_animation:
				"bootscreen/godot":
					animation_player.stop()
					godot_screen.hide()
					animation_player.play("bootscreen/company")
				"bootscreen/company":
					animation_player.stop()
					company_screen.hide()
					SceneLoader.load_scene(main_menu_path)
		
		
		
		
		

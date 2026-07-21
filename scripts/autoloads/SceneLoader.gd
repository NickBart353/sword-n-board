extends Node

signal progress_changed(progress)
signal load_finished
signal load_failed

var loading_screen: PackedScene = preload("uid://c8x8sbc47lju0")
var loaded_Resource: PackedScene
var scene_path: String
var progress: Array[float] = []
var use_sub_threads: bool = true
var is_loading: bool = false

func _ready() -> void:
	set_deferred("process_mode", Node.PROCESS_MODE_ALWAYS)
	set_process(false)

func load_scene(_scene_path: String) -> void:
	if is_loading: return
	is_loading = true
	print("load... sceneloader.gd")
	scene_path = _scene_path
	
	var new_load_screen = loading_screen.instantiate()
	add_child(new_load_screen)
	progress_changed.connect(new_load_screen._on_progress_changed)
	load_finished.connect(new_load_screen._on_load_finished)
	load_failed.connect(new_load_screen._on_load_failed)
	
	await new_load_screen.loading_screen_ready
	
	start_load()

func start_load() -> void:
	print("start... sceneloader.gd")
	var state = ResourceLoader.load_threaded_request(scene_path, "", use_sub_threads)
	if state == OK:
		print("ok... sceneloader.gd")
		set_process(true)
	else:
		print("failed... sceneloader.gd")
		is_loading = false

func _process(_delta: float) -> void:
	var load_status = ResourceLoader.load_threaded_get_status(scene_path, progress)
	if progress.size() > 0:
		progress_changed.emit(progress[0])
	
	match load_status:
		ResourceLoader.THREAD_LOAD_INVALID_RESOURCE, ResourceLoader.THREAD_LOAD_FAILED:
			print("invaid... sceneloader.gd")
			set_process(false)
			is_loading = false
			load_failed.emit()
		ResourceLoader.THREAD_LOAD_LOADED:
			print("succ... sceneloader.gd")
			is_loading = false
			loaded_Resource = ResourceLoader.load_threaded_get(scene_path)
			get_tree().change_scene_to_packed(loaded_Resource)
			load_finished.emit()
			set_process(false)
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			pass
	
	
	
	
	
	
	
	
	
	
	

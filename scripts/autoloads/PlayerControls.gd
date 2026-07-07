extends Node

signal interact_key_updated
signal close_menus

var sensitivity: float = 1.0
var player_input_dictionary: Dictionary = {}
var interact_keybind_text: String = "E"
var _block_input: bool = false
var _block_scrolling: bool = false
var current_player_name: String

var player_camera: Camera3D

func set_player_camera(new_player_camera: Camera3D) -> void:
	player_camera = new_player_camera

func is_position_in_frustrum(world_position: Vector3) -> bool:
	return player_camera.is_position_in_frustum(world_position)

func updated_interact_keybind(keybind: String) -> void:
	interact_keybind_text = keybind
	interact_key_updated.emit(interact_keybind_text)

func input_blocked() -> bool:
	return _block_input

func block_input():
	_block_input = true

func unblock_input():
	_block_input = false

func scrolling_blocked() -> bool:
	return _block_scrolling

func block_scrolling() -> void:
	_block_scrolling = true

func unblock_scrolling() -> void:
	_block_scrolling = false

func close_open_menus() -> void:
	close_menus.emit()

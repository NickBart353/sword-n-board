extends Node

signal interact_key_updated

var sensitivity: float = 1.0
var player_input_dictionary: Dictionary = {}
var interact_keybind_text: String = "E"
var _block_input: bool = false

func updated_interact_keybind(keybind: String) -> void:
	interact_keybind_text = keybind
	interact_key_updated.emit(interact_keybind_text)

func input_blocked() -> bool:
	return _block_input

func block_input():
	_block_input = true

func unblock_input():
	_block_input = false

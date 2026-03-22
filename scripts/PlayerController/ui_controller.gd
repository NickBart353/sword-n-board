extends Node

@export var player: CharacterBody3D

func apply_ui(input: Node, state_controller: Node) -> void:
	pass#if input.pause_menu:
		#UiController.escape_menu()

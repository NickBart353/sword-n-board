extends State
class_name PlayerState

@onready var player: CharacterBody3D = get_tree().get_first_node_in_group("Player")

signal Inventory_Pressed
signal Pause_Menu_Pressed

func Enter() -> void:
	pass

func Exit() -> void:
	pass

func Update(_delta: float) -> void:
	pass

func Physics_Update(_delta: float) -> void:
	if player.input.inventory: 
		Inventory_Pressed.emit()
	
	if player.input.pause_menu: 
		Pause_Menu_Pressed.emit()

class_name WorldLootContainer extends Area3D

@onready var interactable: Interactable = $Interactable

@export var world_event_hash: String
@export var items: Array[ItemData]

var event: bool = false

func _ready() -> void:
	pass

func _on_interactable__interact() -> void:
	UiController.send_items_to_player_inventoy(items)
	event = true
	GameStateSaver.save_game()
	disable_monitoring()

func disable_monitoring() -> void:
	hide()
	monitorable = false
	monitoring = false

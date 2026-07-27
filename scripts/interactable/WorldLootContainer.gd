class_name WorldLootContainer extends Area3D

const RESET_POSITION: Vector3 = Vector3(-10000, -10000, -10000)

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
	global_position = RESET_POSITION
	monitorable = false
	monitoring = false

extends Ability

@onready var anim_player = $"../../AnimationPlayer"

@export_group("StaminaCost")
@export_range(0.0, 100.0) var base_block_cost = 15.0

signal blocked

const allowed_weapons: Array = [ItemData.ITEM_TYPE.SHIELD]

var weapon: Weapon
var offhand: Node
var blocking: bool = false
var process: bool = false

#func set_item(item: Node) -> void:
	#if item is Weapon:
		#if item.data.item_type in allowed_weapons:
			#weapon = item
			#process = true
			#return
	#process = false
	#reset()
func set_item(mainhand: Node, offhand: Node) -> void:
	pass

func apply_ability(input: Node, state_controller: Node, movement: Node, abilities: Node, delta: float) -> void:
	if not process: return
	if not weapon: return
	if not movement.dashing and not state_controller.is_player_busy():
		#if not offhand.blocked.is_connected(_blocked):
			#offhand.blocked.connect(_blocked)
		if input.hold_secondary:
			blocking = true
			#offhand.activate_areas()
		else:
			blocking = false
			#offhand.deactivate_areas()
	elif movement.dashing and blocking:
		blocking = false

func _blocked(body):
	if blocking:
		blocked.emit(body)

func reset():
	#offhand = null
	blocking = false

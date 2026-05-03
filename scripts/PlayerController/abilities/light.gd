extends Ability

@onready var anim_player = $"../../AnimationPlayer"

const allowed_weapons: Array = [ItemData.ITEM_TYPE.TORCH]

var weapon
var offhand: Node
var lighting: bool = false
var process: bool = false

func set_item(item: Node) -> void:
	reset()
	if item is Weapon:
		if item.data.item_type in allowed_weapons:
			weapon = item
			process = true
			return
	process = false

func apply_ability(input: Node, state_controller: Node, movement: Node, abilities: Node, delta: float) -> void:
	if not process: return
	if not offhand == player.get_equipped_secondary() or not offhand:
		offhand = player.get_equipped_secondary()
	if not offhand is Torch: 
		reset()
		return
	if not movement.dashing and not state_controller.is_player_busy():
		if input.hold_secondary:
			lighting = true
		else:
			lighting = false
	elif movement.dashing and lighting:
		lighting = false

func reset():
	#offhand = null
	lighting = false

extends Ability

const allowed_mainhands: Array = []
const allowed_offhands: Array = [ItemData.ITEM_TYPE.TORCH]

var mainhand_weapon: Weapon
var offhand_weapon: Weapon
var offhand: Node
var lighting: bool = false
var process: bool = false

var dualwielding: bool = false

func set_item(mainhand: Node, offhand: Node, dualwield: bool) -> void:
	dualwielding = dualwield
	reset()
	var offhand_valid: bool = _validate_slot(offhand, "offhand") 
	var mainhand_valid: bool = _validate_slot(mainhand, "mainhand")
	if not (offhand_valid or mainhand_valid):
		reset()
	process = (offhand_valid or mainhand_valid)

func _validate_slot(slot: Node, slot_string: String) -> bool:
	if slot is Weapon:
		var testing_array: Array
		match slot_string:
				"offhand":
					testing_array = allowed_offhands
				"mainhand":
					testing_array = allowed_mainhands
		if slot.data.item_type in testing_array or (dualwielding and slot.data.item_type in allowed_offhands):
			match slot_string:
				"offhand":
					offhand_weapon = slot
				"mainhand":
					mainhand_weapon = slot
			return true
	else:
		match slot_string:
			"offhand":
				offhand_weapon = null
			"mainhand":
				mainhand_weapon = null
	return false

func apply_ability(input: Node, state_controller: Node, movement: Node, abilities: Node, delta: float) -> void:
	if not process: return
	if not movement.dashing and not ability_controller.busy:
		if input.hold_secondary:
			lighting = true
			print("test")
		else:
			lighting = false
	elif movement.dashing and lighting:
		lighting = false

func reset():
	#offhand = null
	lighting = false

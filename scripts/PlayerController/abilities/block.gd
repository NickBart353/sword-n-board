extends Ability

@export_group("StaminaCost")
@export_range(0.0, 100.0) var base_block_cost = 15.0

signal blocked

const allowed_mainhands: Array = []

const allowed_offhands: Array = [ItemData.ITEM_TYPE.SHIELD, ItemData.ITEM_TYPE.GREATSWORD, ItemData.ITEM_TYPE.AXE, 
		ItemData.ITEM_TYPE.GREATAXE,  ItemData.ITEM_TYPE.HAMMER,  ItemData.ITEM_TYPE.GREATHAMMER, 
		ItemData.ITEM_TYPE.GREATSHIELD]

const allowed_dualwield: Array = [ItemData.ITEM_TYPE.SPEAR]

var mainhand_weapon: Weapon
var offhand_weapon: Weapon

var mainhand_blocking_component: BlockingComponent
var offhand_blocking_component: BlockingComponent

var blocking: bool = false
var dualwielding: bool = false

var process: bool = false

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
		if slot.data.item_type in testing_array or (dualwielding and slot.data.item_type in allowed_offhands) or (dualwielding and slot.data.item_type in allowed_dualwield):
			match slot_string:
				"offhand":
					offhand_weapon = slot
					offhand_blocking_component = offhand_weapon.get_node_or_null("BlockingComponent")
					if offhand_blocking_component:
						offhand_blocking_component.disable_monitoring()
						if not offhand_blocking_component.blocked.is_connected(_blocked):
							offhand_blocking_component.blocked.connect(_blocked)
					else:
						print("no blocking component found for: ", offhand_weapon.data.item_id, " : ", offhand_weapon.data.item_name)
				"mainhand":
					mainhand_weapon = slot
					mainhand_blocking_component = mainhand_weapon.get_node_or_null("BlockingComponent")
					if mainhand_blocking_component:
						mainhand_blocking_component.disable_monitoring()
						if not mainhand_blocking_component.blocked.is_connected(_blocked):
							mainhand_blocking_component.blocked.connect(_blocked)
					else:
						print("no blocking component found for: ", offhand_weapon.data.item_id, " : ", offhand_weapon.data.item_name)
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
	if not movement.dashing and not abilities.busy:
		if input.hold_secondary:
			
			blocking = true
			if offhand_blocking_component:
				offhand_blocking_component.enable_monitoring()
			if mainhand_blocking_component:
				mainhand_blocking_component.enable_monitoring()
		else:
			blocking = false
			if offhand_blocking_component:
				offhand_blocking_component.disable_monitoring()
			if mainhand_blocking_component:
				mainhand_blocking_component.disable_monitoring()
	elif movement.dashing and blocking:
		blocking = false

func _blocked(body):
	if blocking:
		blocked.emit(body)

func reset():
	#offhand = null
	blocking = false

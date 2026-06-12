extends Ability

@export_group("StaminaCost")
@export_range(0.0, 100.0) var base_parry_cost = 15.0

signal parried

const allowed_mainhands: Array = []
const allowed_offhands: Array = [ItemData.ITEM_TYPE.SHORTSWORD, ItemData.ITEM_TYPE.DAGGER, ItemData.ITEM_TYPE.KATANA]
const allowed_dualwield: Array = []

var mainhand_weapon: Weapon
var offhand_weapon: Weapon

var mainhand_parry_component: ParryComponent
var offhand_parry_component: ParryComponent

var dualwielding: bool = false
var parry: bool = false
var process: bool = false

var bodies: Array = []

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
					offhand_parry_component = offhand_weapon.get_node_or_null("ParryComponent")
					if offhand_parry_component:
						offhand_parry_component.disable_monitoring()
						if not offhand_parry_component.parried.is_connected(_parried):
							offhand_parry_component.parried.connect(_parried)
					else:
						print("no parry component found for: ", offhand_weapon.data.item_id, " : ", offhand_weapon.data.item_name)
				"mainhand":
					mainhand_weapon = slot
					mainhand_parry_component = mainhand_weapon.get_node_or_null("ParryComponent")
					if mainhand_parry_component:
						mainhand_parry_component.disable_monitoring()
						if not mainhand_parry_component.parried.is_connected(_parried):
							mainhand_parry_component.parried.connect(_parried)
					else:
						print("no parry component found for: ", offhand_weapon.data.item_id, " : ", offhand_weapon.data.item_name)
			return true
	else:
		match slot_string:
			"offhand":
				offhand_weapon = null
			"mainhand":
				mainhand_weapon = null
	return false

func apply_ability(input: Node, _state_controller: Node, movement: Node, _abilities: Node, _delta: float) -> void:
	if not process: return
	if not movement.dashing and not ability_controller.busy:
		if input.secondary:
			if player.use_stamina(base_parry_cost):
				ability_controller.busy = true
				parry = true
			
	elif movement.dashing and parry:
		parry = false

func _parried(body):
	if parry and not body in bodies:
		bodies.append(body)
		parried.emit(body)

func __parry_window_start():#gets called in animation
	if mainhand_parry_component:
		mainhand_parry_component.enable_monitoring()
	if offhand_parry_component:
		offhand_parry_component.enable_monitoring()
	parry = true

func __parry_window_end():#gets called in animation
	if mainhand_parry_component:
		mainhand_parry_component.disable_monitoring()
	if offhand_parry_component:
		offhand_parry_component.disable_monitoring()
	parry = false
	ability_controller.busy = false
	bodies.clear()

func reset():
	parry = false

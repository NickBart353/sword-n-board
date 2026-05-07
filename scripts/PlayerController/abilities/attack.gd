extends Ability

@onready var anim_player = $"../../AnimationPlayer"
@onready var attack_timer = $"../../Timers/AttackTimer"

@export_group("StaminaCost")
@export_range(0.0, 100.0) var attack_cost = 15.0

const allowed_mainhands: Array = [ItemData.ITEM_TYPE.SHORTSWORD, ItemData.ITEM_TYPE.GREATSWORD, ItemData.ITEM_TYPE.GREATAXE, 
	ItemData.ITEM_TYPE.AXE, ItemData.ITEM_TYPE.DAGGER, ItemData.ITEM_TYPE.GREATHAMMER, 
	ItemData.ITEM_TYPE.KATANA, ItemData.ITEM_TYPE.SPEAR, ItemData.ITEM_TYPE.TORCH, ItemData.ITEM_TYPE.SHIELD, 
	ItemData.ITEM_TYPE.FIST
	]

const allowed_offhands: Array = [ItemData.ITEM_TYPE.SPEAR]

var bodies: Array = []

var mainhand_swing: int = 0
var mainhand_swinging: bool = false
var mainhand_swing_in_progress: bool = false

var offhand_swing: int = 0
var offhand_swinging: bool = false
var offhand_swing_in_progress: bool = false

var mainhand_weapon: Weapon
var offhand_weapon: Weapon

var mainhand_combo_count: int = 0
var offhand_combo_count: int = 0

var process: bool = false

func set_item(mainhand: Node, offhand: Node) -> void:
	var weapons_valid = _validate_slot(offhand, "offhand") or _validate_slot(mainhand, "mainhand")
	if not weapons_valid:
		reset()
	process = weapons_valid

func _validate_slot(slot: Node, slot_string: String) -> bool:
	if slot is Weapon:
		var testing_array: Array
		match slot_string:
				"offhand":
					testing_array = allowed_offhands
				"mainhand":
					testing_array = allowed_mainhands
		if slot.data.item_type in testing_array:
			var weapon_slot: Weapon
			match slot_string:
				"offhand":
					weapon_slot = offhand_weapon
					offhand_combo_count = slot.data.combo_size
				"mainhand":
					weapon_slot = mainhand_weapon
					mainhand_combo_count = slot.data.combo_size
			weapon_slot = slot
			if not weapon_slot.hit.is_connected(_melee_attack):
				weapon_slot.hit.is_connected(_melee_attack)
				return true
	return false

func apply_ability(input: Node, state_controller: Node, movement: Node, abilities: Node, delta: float) -> void:	
	if not process: return
	if not movement.dashing and not state_controller.is_player_busy() and not ability_controller.busy:
		print("mainhand ", mainhand_weapon)
		print("offhand ", offhand_weapon)
		if input.primary and not mainhand_swing_in_progress and player.use_stamina(attack_cost):
			ability_controller.busy = true
			bodies = []
			mainhand_swinging = true
			mainhand_swing_in_progress = true
			if mainhand_swing == 0 or mainhand_swing == mainhand_combo_count or mainhand_swing == mainhand_combo_count:
				mainhand_swing = 1
			else:
				mainhand_swing += 1
		if input.secondary and not offhand_swing_in_progress and player.use_stamina(attack_cost):
			ability_controller.busy = true
			bodies = []
			offhand_swinging = true
			offhand_swing_in_progress = true
			if offhand_swing == 0 or offhand_swing == offhand_combo_count or offhand_swing == offhand_combo_count:
				offhand_swing = 1
			else:
				offhand_swing += 1

func _melee_attack(body, damage):
	#if swing_in_progress:
	if not body in bodies:
		bodies.append(body)
		body.take_damage(damage)

func _on_attack_timer_timeout() -> void:
	if not mainhand_swing_in_progress:
		mainhand_swing = 0
		ability_controller.busy = false
	if not offhand_swing_in_progress:
		offhand_swing = 0
		ability_controller.busy = false

func _attack_started() -> void:
	if mainhand_swing_in_progress:
		mainhand_weapon.monitoring = true
		mainhand_swinging = false
	if offhand_swing_in_progress:
		offhand_weapon.monitoring = true
		offhand_swinging = false

func _attack_ended() -> void:
	bodies.clear()
	mainhand_weapon.monitoring = true
	mainhand_swinging = false
	offhand_weapon.monitoring = true
	offhand_swinging = false
	attack_timer.start()
	ability_controller.busy = false

func reset():
	#weapon = null
	bodies = []
	mainhand_swinging = false
	mainhand_combo_count = 0
	offhand_swinging = false
	offhand_combo_count = 0
	ability_controller.busy = false

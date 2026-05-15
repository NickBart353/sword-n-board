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

var mainhand_bodies: Array = []
var offhand_bodies: Array = []

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

var dualwielding: bool = false

var process: bool = false

func set_item(mainhand: Node, offhand: Node, dualwield: bool) -> void:
	dualwielding = dualwield
	reset()
	var offhand_valid: bool = _validate_slot(offhand, "offhand") 
	var mainhand_valid: bool = _validate_slot(mainhand, "mainhand")
	if not (offhand_valid or mainhand_valid):
		reset()
	else:
		if mainhand.data.item_id == offhand.data.item_id:
			mainhand_combo_count = mainhand.data.dualwield_combo_size
	process = (offhand_valid or mainhand_valid)

func _validate_slot(slot: Node, slot_string: String) -> bool:
	if slot is Weapon:
		var testing_array: Array
		match slot_string:
				"offhand":
					testing_array = allowed_offhands
				"mainhand":
					testing_array = allowed_mainhands
		if slot.data.item_type in testing_array or (dualwielding and slot.data.item_type in allowed_mainhands):
			match slot_string:
				"offhand":
					offhand_weapon = slot
					offhand_combo_count = slot.data.combo_size
					if not offhand_weapon.hit.is_connected(_offhand_attack):
						offhand_weapon.hit.connect(_offhand_attack)
				"mainhand":
					mainhand_weapon = slot
					mainhand_combo_count = slot.data.combo_size
					if not mainhand_weapon.hit.is_connected(_mainhand_attack):
						mainhand_weapon.hit.connect(_mainhand_attack)
			return true
	else:
		match slot_string:
			"offhand":
				offhand_weapon = null
			"mainhand":
				mainhand_weapon = null
	return false

func apply_ability(input: Node, state_controller: Node, movement: Node, _abilities: Node, _delta: float) -> void:
	if not process: return
	if ability_controller.busy and (not mainhand_swing_in_progress and not offhand_swing_in_progress) and not attack_timer.time_left:
		reset()
	if not movement.dashing and not state_controller.is_player_busy() and not ability_controller.busy:
		if input.primary and not mainhand_swing_in_progress and offhand_swing == 0 and mainhand_weapon:
			if player.use_stamina(attack_cost):
				ability_controller.busy = true
				mainhand_bodies.clear()
				offhand_bodies.clear()
				mainhand_swinging = true
				mainhand_swing_in_progress = true
				if mainhand_swing == 0 or mainhand_swing == mainhand_combo_count:
					mainhand_swing = 1
				else:
					mainhand_swing += 1
		if input.secondary and not offhand_swing_in_progress and mainhand_swing == 0 and offhand_weapon and not dualwielding:
			if player.use_stamina(attack_cost):
				ability_controller.busy = true
				mainhand_bodies.clear()
				offhand_bodies.clear()
				offhand_swinging = true
				offhand_swing_in_progress = true
				if offhand_swing == 0 or offhand_swing == offhand_combo_count:
					offhand_swing = 1
				else:
					offhand_swing += 1

func _mainhand_attack(body, damage):
	if not body in mainhand_bodies:
		mainhand_bodies.append(body)
		body.take_damage(damage)

func _offhand_attack(body, damage):
	if not body in offhand_bodies:
		offhand_bodies.append(body)
		body.take_damage(damage)

func _on_attack_timer_timeout() -> void:
	if not mainhand_swing_in_progress and not offhand_swing_in_progress:
		reset()
	#if not mainhand_swing_in_progress:
		#mainhand_swing_in_progress = false
		#mainhand_swing = 0
	#if not offhand_swing_in_progress:
		#offhand_swing_in_progress = false
		#offhand_swing = 0
	#ability_controller.busy = false

func _attack_started() -> void:
	if mainhand_swing_in_progress:
		mainhand_weapon.monitoring = true
		mainhand_swinging = false
		if dualwielding:
			offhand_weapon.monitoring = true
	if offhand_swing_in_progress:
		offhand_weapon.monitoring = true
		offhand_swinging = false

func _attack_ended() -> void:
	mainhand_bodies.clear()
	offhand_bodies.clear()
	if mainhand_swing_in_progress:
		mainhand_weapon.monitoring = false
		mainhand_swinging = false
		mainhand_swing_in_progress = false
		if dualwielding:
			offhand_weapon.monitoring = false
	if offhand_swing_in_progress:
		offhand_weapon.monitoring = false
		offhand_swinging = false
		offhand_swing_in_progress = false
	attack_timer.start()
	ability_controller.busy = false

func reset():
	mainhand_bodies.clear()
	offhand_bodies.clear()
	mainhand_swing = 0
	mainhand_swinging = false
	mainhand_swing_in_progress = false
	if mainhand_weapon:
		mainhand_weapon.monitoring = false
	if offhand_weapon:
		offhand_weapon.monitoring = false
	#mainhand_combo_count = 0
	offhand_swing = 0
	offhand_swinging = false
	offhand_swing_in_progress = false
	#offhand_combo_count = 0
	ability_controller.busy = false

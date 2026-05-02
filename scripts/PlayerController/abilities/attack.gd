extends Ability

@onready var anim_player = $"../../AnimationPlayer"
@onready var attack_timer = $"../../Timers/AttackTimer"

@export_group("StaminaCost")
@export_range(0.0, 100.0) var attack_cost = 15.0

const allowed_weapons: Array = [ItemData.ITEM_TYPE.SHORTSWORD, ItemData.ITEM_TYPE.GREATSWORD, 
	ItemData.ITEM_TYPE.AXE, ItemData.ITEM_TYPE.DAGGER, ItemData.ITEM_TYPE.GREATHAMMER, 
	ItemData.ITEM_TYPE.KATANA, ItemData.ITEM_TYPE.SPEAR, ItemData.ITEM_TYPE.TORCH, ItemData.ITEM_TYPE.SHIELD, 
	ItemData.ITEM_TYPE.FIST
	]

var weapon: Weapon
var bodies: Array = []
var swing: int = 0
var swinging: bool = false
var swing_in_progress: bool = false
var combo_count: int = 0
var process: bool = false

func set_item(item: Node) -> void:
	if item is Weapon:
		if item.data.item_type in allowed_weapons:
			weapon = item
			combo_count = item.data.combo_size
			if not weapon.hit.is_connected(_melee_attack):
				weapon.hit.connect(_melee_attack)
			process = true
			return
	process = false
	reset()

func apply_ability(input: Node, state_controller: Node, movement: Node, abilities: Node, delta: float) -> void:	
	if not process: return
	if not movement.dashing and not state_controller.is_player_busy():
		if input.attack and not swing_in_progress and player.use_stamina(attack_cost):
			bodies = []
			swinging = true
			swing_in_progress = true
			if swing == 0 or swing == combo_count:
				swing = 1
			else:
				swing += 1

func _melee_attack(body, damage):
	#if swing_in_progress:
	if not body in bodies:
		bodies.append(body)
		body.take_damage(damage)

func _on_attack_timer_timeout() -> void:
	if not swing_in_progress:
		swing = 0

func _attack_started() -> void:
	weapon.monitoring = true
	swinging = false

func _attack_ended() -> void:
	bodies.clear()
	weapon.monitoring = false
	swing_in_progress = false
	attack_timer.start()

func reset():
	#weapon = null
	bodies = []
	swing = 0
	swinging = false
	swing_in_progress = false

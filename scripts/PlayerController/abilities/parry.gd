extends Ability

@onready var anim_player = $"../../AnimationPlayer"

@export_group("StaminaCost")
@export_range(0.0, 100.0) var base_parry_cost = 15.0

signal parried

const allowed_weapons: Array = [ItemData.ITEM_TYPE.SHORTSWORD, ItemData.ITEM_TYPE.DAGGER, ItemData.ITEM_TYPE.KATANA]

var weapon: Weapon
var parry: bool = false
var process: bool = false

func set_item(item: Node) -> void:
	if item is Weapon:
		if item.data.item_type in allowed_weapons:
			#if not weapon.parry.is_connected(_parried):
				#weapon.parry.connect(_parried)
			weapon = item
			process = true
			return
	process = false
	reset()

func apply_ability(input: Node, state_controller: Node, movement: Node, abilities: Node, delta: float) -> void:
	if not process: return
	if not weapon: return
	if not movement.dashing and not state_controller.is_player_busy():
		if input.secondary:
			parry = true
			weapon.monitoring = true
	elif movement.dashing and parry:
		parry = false

func _parried(body):
	if parry:
		parried.emit(body)

func parry_finished():#gets called in animation
	parry = false
	weapon.monitoring = false

func reset():
	#offhand = null
	parry = false

extends Ability

@onready var anim_player = $"../../AnimationPlayer"
@onready var attack_timer = $"../../Timers/AttackTimer"

var weapon: Node
var bodies: Array = []
var swing: int = 0
var swinging: bool = false
var swing_in_progress: bool = false

func apply_ability(input: Node, movement: Node, abilities: Node, delta: float) -> void:
	weapon = player.get_equipped_primary()
	if not weapon is MeleeWeapon: return
	
	if not weapon.hit.is_connected(_melee_attack):
		weapon.hit.connect(_melee_attack)
	
	if not movement.dashing:
		if input.primary and not swing_in_progress:
			bodies = []
			swinging = true
			swing_in_progress = true
			if swing == 0 or swing == 3:
				swing = 1
			else:
				swing += 1

func _melee_attack(body, damage):
	if swing_in_progress:
		if not body in bodies:
			bodies.append(body)
			body.take_damage(damage)

func _on_attack_timer_timeout() -> void:
	if not swing_in_progress:
		swing = 0

func _sword_animation_started(anim_name: StringName) -> void:
	if anim_name == "Sword{0}".format([swing]):
		swinging = false

func _sword_animation_ended(anim_name: StringName) -> void:
	if anim_name == "Sword{0}".format([swing]):
		bodies.clear()
		swing_in_progress = false
		attack_timer.start()
		if not weapon is MeleeWeapon: return
		weapon.set_collision_mask_value(1, false)
		weapon.set_collision_mask_value(1, true)
		

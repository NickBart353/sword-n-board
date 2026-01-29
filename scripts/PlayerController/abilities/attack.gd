extends Ability

@onready var anim_player = $"../../AnimationPlayer"

var weapon: Node
var bodies: Array = []
var swing_one: bool
var swing_two: bool
var swing_three: bool

func _ready() -> void:
	pass

func apply_ability(input: Node, movement: Node, abilities: Node, delta: float) -> void:
	weapon = player.get_equipped_primary()
	if not weapon.hit.is_connected(_melee_attack):
		weapon.hit.connect(_melee_attack)
	
	if not movement.dashing:
		if input.primary:
			if not swing_one:
				swing_one = true
			elif not swing_two and swing_one:
				swing_two = true
			elif not swing_three and swing_two and swing_three:
				swing_three = true

func _melee_attack(body, damage):
	if not body in bodies:
		bodies.append(body)
		body.take_damage(damage)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Sword1":
		$"../../Timers/AttackTimer".start()
		bodies.clear()
	elif anim_name == "Sword2":
		$"../../Timers/AttackTimer".start()
		bodies.clear()
	elif anim_name == "Sword3":
		$"../../Timers/AttackTimer".start()
		bodies.clear()

func _on_attack_timer_timeout() -> void:
	swing_one = false
	swing_two = false
	swing_three = false

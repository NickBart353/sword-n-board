extends Ability

@onready var anim_player = $"../../AnimationPlayer"

signal spawn_projectile

var offhand: Node
var blocking: bool = false

func apply_ability(input: Node, movement: Node, abilities: Node, delta: float) -> void:
	offhand = player.get_equipped_secondary()
	if not offhand is Shield: 
		reset()
		return
	
	if not movement.dashing:
		if input.hold_secondary:
			blocking = true
		else:
			blocking = false

func reset():
	offhand = null
	blocking = false

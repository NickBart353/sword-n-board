extends Ability

@onready var anim_player = $"../../AnimationPlayer"

var offhand: Node
var lighting: bool = false

func apply_ability(input: Node, movement: Node, abilities: Node, delta: float) -> void:
	offhand = player.get_equipped_secondary()
	if not offhand is Torch: 
		reset()
		return
	if not movement.dashing:
		if input.hold_secondary:
			lighting = true
		else:
			lighting = false
	elif movement.dashing and lighting:
		lighting = false

func reset():
	offhand = null
	lighting = false

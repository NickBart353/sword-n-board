extends Ability

@onready var anim_player = $"../../AnimationPlayer"

signal blocked

var offhand: Node
var blocking: bool = false

func apply_ability(input: Node, movement: Node, abilities: Node, delta: float) -> void:
	offhand = player.get_equipped_secondary()
	if not offhand is Shield: 
		reset()
		return
	if not movement.dashing:
		if not offhand.blocked.is_connected(_blocked):
			offhand.blocked.connect(_blocked)
		
		if not movement.dashing:
			if input.hold_secondary:
				blocking = true
				offhand.activate_areas()
			else:
				blocking = false
				offhand.deactivate_areas()
	elif movement.dashing and blocking:
		blocking = false

func _blocked(body):
	if blocking:
		blocked.emit(body)

func reset():
	offhand = null
	blocking = false

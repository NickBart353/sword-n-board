extends Ability

@onready var anim_player = $"../../AnimationPlayer"

var consumable: Node
var consuming: bool = false

func apply_ability(input: Node, movement: Node, abilities: Node, delta: float) -> void:
	consumable = player.get_equipped_consumable()
	if not consumable is Consumable:
		reset()
		return
	if not movement.dashing:
		if not consumable.consumed.is_connected(_consumed):
			consumable.consumed.connect(_consumed)
		if input.consume and not consuming:
			consuming = true
			consumable.consume()

func _consumed():
	pass

func reset():
	consumable = null
	consuming = false

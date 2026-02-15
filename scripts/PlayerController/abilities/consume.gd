extends Ability

@onready var anim_player = $"../../AnimationPlayer"

signal consume_item
signal finished_consuming

var consumable: Node
var consuming: bool = false
var consumed: bool = false

func apply_ability(input: Node, state_controller: Node, movement: Node, abilities: Node, delta: float) -> void:
	consumable = player.get_equipped_consumable()
	if not consumable is Consumable:
		reset()
		return
	if not movement.dashing:
		if input.consume and not consuming:
			state_controller.update_state(StateController.STATE.CONSUMING)
			consuming = true
		elif consumed and state_controller.current_state == StateController.STATE.CONSUMING:
			state_controller.update_state(StateController.STATE.IDLE)
			finished_consuming.emit()
			consuming = false
			consumed = false

func _consumed():
	consume_item.emit(consumable.property, consumable.property_type, consumable.amount)

func done_consuming():
	consumed = true

func reset():
	consumable = null
	consuming = false

extends Ability

@onready var anim_player = $"../../AnimationPlayer"

signal consume_item
signal finished_consuming

var consumable: Node
var consuming: bool = false
var consumed: bool = false

func apply_ability(input: Node, state_controller: Node, movement: Node, abilities: Node, delta: float) -> void:
	if not consumable == player.get_equipped_consumable() or not consumable:
		consumable = player.get_equipped_consumable()
	if not consumable is Consumable:
		reset()
		return
	if not movement.dashing:
		if input.consume and not consuming and not state_controller.is_player_busy():
			state_controller.update_action_state(StateController.ACTION_STATE.CONSUMING)
			consuming = true
		elif consumed and state_controller.is_player_busy():
			state_controller.reset_action_state()
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

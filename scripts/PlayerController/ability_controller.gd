extends Node

func apply_abilities(input: Node, state_controller: Node, movement: Node, delta: float) -> void:
	for ability in get_children():
		ability.apply_ability(input, state_controller, movement, self, delta)

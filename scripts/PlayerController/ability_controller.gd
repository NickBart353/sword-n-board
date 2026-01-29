extends Node

func apply_abilities(input: Node, movement: Node, delta: float) -> void:
	for ability in get_children():
		ability.apply_ability(input, movement, self, delta)

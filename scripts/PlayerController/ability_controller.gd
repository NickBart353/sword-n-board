extends Node

var busy: bool = false

func _ready() -> void:
	for ability in get_children():
		ability.ability_controller = self

func apply_abilities(input: Node, state_controller: Node, movement: Node, delta: float) -> void:
	for ability in get_children():
		ability.apply_ability(input, state_controller, movement, self, delta)

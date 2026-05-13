@abstract
class_name Ability extends Node

@export var player: CharacterBody3D
var ability_controller: Node

@abstract func apply_ability(input: Node, state_controller: Node, movement: Node, abilites: Node, delta: float) -> void

@abstract func reset() -> void

@abstract func set_item(mainhand: Node, offhand: Node, dualwield: bool) -> void

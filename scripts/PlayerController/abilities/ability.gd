@abstract
class_name Ability extends Node

@export var player: CharacterBody3D

@abstract func apply_ability(input: Node, state_controller: Node, movement: Node, abilites: Node, delta: float) -> void

@abstract func reset() -> void

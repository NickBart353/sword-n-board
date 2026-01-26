extends Node
class_name State

var state_active = false

signal Transitioned
signal Died

func Enter():
	state_active = true

func Exit():
	state_active = false

func Update(_delta: float) -> void:
	pass

func Physics_Update(_delta: float) -> void:
	pass

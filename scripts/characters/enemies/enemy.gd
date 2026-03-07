@abstract
class_name Enemy extends CharacterBody3D

signal died

@export var MIN_HEALTH = 0
@export var MAX_HEALTH = 1000
@export var anim_tree: AnimationTree

var level: int = 1
var origin_position: Vector3
var health

const RESET_POSITION: Vector3 = Vector3(-100000, -100000, -100000)

@abstract func take_damage(damage_dealt, body = null)

@abstract func force_engage()

func _remove_me():
	EventBus.spawn_loot.emit(self)
	EventBus.remove_me.emit(self)
	died.emit()

extends Node

signal create_vfx

const POISON_EXPLOSION: PackedScene = preload("res://scenes/VFX/poison_explosion.tscn")
const SMALL_TORNADO: PackedScene = preload("res://scenes/VFX/spinning_small_tornado.tscn")
const CHARGE_POISON: PackedScene = preload("res://scenes/VFX/charge_poison.tscn")
const STUNNED: PackedScene = preload("res://scenes/VFX/stunned.tscn")

func create_poison_explosion(position: Vector3, local = false):
	if not local:
		create_vfx.emit(position, POISON_EXPLOSION)
	else:
		return POISON_EXPLOSION

func create_small_tornado(position: Vector3, local = false):
	if not local:
		create_vfx.emit(position, SMALL_TORNADO)
	else:
		return SMALL_TORNADO

func create_charge_poison(position: Vector3, local = false):
	if not local:
		create_vfx.emit(position, CHARGE_POISON)
	else:
		return CHARGE_POISON

func create_stunned(position: Vector3, local = false):
	if not local:
		create_vfx.emit(position, STUNNED)
	else:
		return STUNNED

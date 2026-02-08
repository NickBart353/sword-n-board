extends Node

signal create_vfx

const POISON_EXPLOSION: PackedScene = preload("res://scenes/VFX/poison_explosion.tscn")
const SMALL_TORNADO: PackedScene = preload("res://scenes/VFX/spinning_small_tornado.tscn")
const CHARGE_POISON: PackedScene = preload("res://scenes/VFX/charge_poison.tscn")
const STUNNED: PackedScene = preload("res://scenes/VFX/stunned.tscn")
const SOUND_WAVES: PackedScene = preload("res://scenes/VFX/sound_waves.tscn")

const VFX: Dictionary = {
	"POISON_EXPLOSION" : preload("res://scenes/VFX/poison_explosion.tscn"),
	"SMALL_TORNADO" : preload("res://scenes/VFX/spinning_small_tornado.tscn"),
	"CHARGE_POISON" : preload("res://scenes/VFX/charge_poison.tscn"),
	"STUNNED" : preload("res://scenes/VFX/stunned.tscn"),
	"SOUND_WAVES" : preload("res://scenes/VFX/sound_waves.tscn"),
}

func create_vfx_from_string(vfx_name: String, position: Vector3, local = false):
	if VFX.get(vfx_name):
		if not local:
			create_vfx.emit(position, VFX.get(vfx_name))
		else:
			return VFX.get(vfx_name)

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

func create_sound_waves(position: Vector3, local = false):
	if not local:
		create_vfx.emit(position, SOUND_WAVES)
	else:
		return SOUND_WAVES

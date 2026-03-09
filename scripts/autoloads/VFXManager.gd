extends Node

signal create_vfx

const POISON_EXPLOSION: PackedScene = preload("res://scenes/VFX/poison_explosion.tscn")
const SMALL_TORNADO: PackedScene = preload("res://scenes/VFX/spinning_small_tornado.tscn")
const CHARGE_POISON: PackedScene = preload("res://scenes/VFX/charge_poison.tscn")
const STUNNED: PackedScene = preload("res://scenes/VFX/stunned.tscn")
const SOUND_WAVES: PackedScene = preload("res://scenes/VFX/sound_waves.tscn")
const MAGIC_EXPLOSION: PackedScene = preload("res://scenes/VFX/blue_magic_explosion.tscn")
const DIRT_EXPLOSION: PackedScene = preload("res://scenes/VFX/dirt_explosion.tscn")
const CHARGE_TOXIC: PackedScene = preload("res://scenes/VFX/charge_toxic.tscn")
const TOXIC_GROUND: PackedScene = preload("res://scenes/VFX/toxic_ground.tscn")
const CHARGE_ERUPTION: PackedScene = preload("res://scenes/VFX/charge_eruption.tscn")
const RUMBLING: PackedScene = preload("res://scenes/VFX/rumbling.tscn")
const LINE_GROUND_IMPACT: PackedScene = preload("res://scenes/VFX/line_ground_impact.tscn")

enum VFX {POISON_EXPLOSION, SMALL_TORNADO, CHARGE_POISON, STUNNED, SOUND_WAVES, MAGIC_EXPLOSION, DIRT_EXPLOSION, CHARGE_TOXIC, 
TOXIC_GROUND, CHARGE_ERUPTION, RUMBLING, LINE_GROUND_IMPACT, BIG_KILL_PARTICLE, LOOT_PUFF, CRUNCH_PARTICLES}

const VFX_DICT: Dictionary = {
	VFX.POISON_EXPLOSION : preload("res://scenes/VFX/poison_explosion.tscn"),
	VFX.SMALL_TORNADO : preload("res://scenes/VFX/spinning_small_tornado.tscn"),
	VFX.CHARGE_POISON : preload("res://scenes/VFX/charge_poison.tscn"),
	VFX.STUNNED : preload("res://scenes/VFX/stunned.tscn"),
	VFX.SOUND_WAVES : preload("res://scenes/VFX/sound_waves.tscn"),
	VFX.MAGIC_EXPLOSION : preload("res://scenes/VFX/blue_magic_explosion.tscn"),
	VFX.DIRT_EXPLOSION : preload("res://scenes/VFX/dirt_explosion.tscn"),
	VFX.CHARGE_TOXIC : preload("res://scenes/VFX/charge_toxic.tscn"),
	VFX.TOXIC_GROUND : preload("res://scenes/VFX/toxic_ground.tscn"),
	VFX.CHARGE_ERUPTION : preload("res://scenes/VFX/charge_eruption.tscn"),
	VFX.RUMBLING : preload("res://scenes/VFX/rumbling.tscn"),
	VFX.LINE_GROUND_IMPACT : preload("res://scenes/VFX/line_ground_impact.tscn"),
	VFX.BIG_KILL_PARTICLE : preload("res://scenes/VFX/big_kill_particle.tscn"),
	VFX.LOOT_PUFF : preload("res://scenes/VFX/loot_puff.tscn"),
	VFX.CRUNCH_PARTICLES : preload("res://scenes/VFX/crunched_particles.tscn"),
}

func create_vfx_from_enum(vfx_name: VFX, position: Vector3, local: bool = false, new_global_rotation = null):
	if VFX_DICT.get(vfx_name):
		if not local:
			create_vfx.emit(position, VFX_DICT.get(vfx_name), new_global_rotation)
		else:
			return VFX_DICT.get(vfx_name)

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

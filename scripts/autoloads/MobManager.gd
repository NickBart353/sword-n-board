extends Node

enum MOBS {WASP, EATER_PLANT, RAT}

const MOB_DICT: Dictionary = {
	MOBS.WASP : preload("res://scenes/component_scenes/characters/enemies/wasp_new.tscn"),
	MOBS.EATER_PLANT : preload("res://scenes/component_scenes/characters/enemies/eater_plant.tscn"),
	MOBS.RAT : preload("res://scenes/component_scenes/characters/enemies/rat.tscn"),
}

func spawn_mob_from_enum(mob_type: MOBS):
	return MOB_DICT[mob_type]

extends GutTest

var main_game: PackedScene = preload("uid://23kjgnpf3t1i")

func test_all_ids() -> void:
	var game_instance: Node3D
	if main_game.can_instantiate():
		game_instance = main_game.instantiate()
	else:
		assert_eq(true, false)
	
	var mobspawns: Node3D = game_instance.get_node("MobSpawns")
	var worldloot: Node3D = game_instance.get_node("WorldLoot")
	
	assert_eq(_compare_mobs(mobspawns) and _compare_loot(worldloot) and _compare_chests(), true)

func _compare_chests() -> bool:
	var chests: Array = get_tree().get_nodes_in_group("Chest")
	var seen_dict: Dictionary = {}
	for chest in chests:
		if chest.chest_id == "":
			return false
		if seen_dict.get(chest.chest_id) == null:
			seen_dict.set(chest.chest_id, true)
		else:
			return false
	return true

func _compare_loot(worldloot: Node3D) -> bool:
	var seen_dict: Dictionary = {}
	for loot_container in worldloot.get_children():
		if loot_container is WorldLootContainer:
			if loot_container.world_event_hash == "":
				return false
			if seen_dict.get(loot_container.world_event_hash) == null:
				seen_dict.set(loot_container.world_event_hash, true)
			else:
				return false
	return true

func _compare_mobs(mobspawns: Node3D) -> bool:
	var seen_dict: Dictionary = {}
	for mob_spawn_group in mobspawns.get_children():
		if mob_spawn_group is MobTypePicker:
			for mob_spawn in mob_spawn_group.get_children():
				if mob_spawn is MobSpawn:
					if mob_spawn.spawn_id == "":
						return false
					if seen_dict.get(mob_spawn.spawn_id) == null:
						seen_dict.set(mob_spawn.spawn_id, true)
					else:
						return false
	return true

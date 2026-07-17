extends Node

signal get_items_from_inventory

var basic_data_timer: Timer

var player: Player

var save_file_resource: SaveFile
var current_save_task_id: int
var current_savemanager_task_id: int

var temp_inventory: Array[ItemData]
var temp_head: ItemData
var temp_body: ItemData
var temp_boots: ItemData
var temp_mainhand: ItemData
var temp_offhand: ItemData
var temp_consumable: ItemData
var temp_consumable_list: Array[ItemData]

func _ready() -> void:
	CombatManager.left_combat.connect(_save_everything)
	SaveFileManager.new_savefile_loaded.connect(_update_savefile)
	
	player = get_tree().get_first_node_in_group("Player")
	
	basic_data_timer = Timer.new()
	basic_data_timer.autostart = false
	basic_data_timer.wait_time = 10
	
	if not basic_data_timer.timeout.is_connected(_basic_timer_timeout):
		basic_data_timer.timeout.connect(_basic_timer_timeout)
	add_child(basic_data_timer)

func _update_savefile(new_savefile_id: String) -> void:
	save_file_resource = SaveFileManager.load_savefile(new_savefile_id)

func load_save() -> void:
	save_file_resource = SaveFileManager.load_savefile(SaveFileManager.current_savefile_id)

func _save() -> void:
	_save_multithreaded()

func _save_multithreaded():
	if CombatManager.is_in_combat():
		return
	if current_savemanager_task_id:
		if not WorkerThreadPool.is_task_completed(current_savemanager_task_id):
			return
			
	if not player:
		player = get_tree().get_first_node_in_group("Player")
	if not player or not player.is_on_floor():
		return
		
	_save_dead_enemies() 
	_save_chests()
	_save_world_events()
	get_items_from_inventory.emit()
	
	var snapshot: SaveFile = SaveFile.new()
	
	snapshot = save_file_resource
	
	snapshot.health = player.HEALTH
	snapshot.stamina = player.STAMINA
	snapshot.mana = player.MANA
	snapshot.position = player.global_position
	snapshot.rotation = player.global_rotation
	snapshot.character_name = save_file_resource.character_name 
	snapshot.last_played_date = Time.get_datetime_string_from_system(false, true)
	snapshot.dead_mobs = save_file_resource.dead_mobs.duplicate(false)
	snapshot.world_events = save_file_resource.world_events.duplicate(false)
	
	var cloned_inventory: Array[ItemData] = []
	for item_data in temp_inventory:
		if item_data:
			cloned_inventory.append(item_data.duplicate(true))
	snapshot.player_items = cloned_inventory
	
	var get_cloned_item = func(original_data: ItemData) -> ItemData:
		if not original_data: 
			return null
		for clone in cloned_inventory:
			if clone.unique_id == original_data.unique_id:
				return clone
		return null
	
	snapshot.head = get_cloned_item.call(temp_head)
	snapshot.body = get_cloned_item.call(temp_body)
	snapshot.boots = get_cloned_item.call(temp_boots)
	snapshot.mainhand = get_cloned_item.call(temp_mainhand)
	snapshot.offhand = get_cloned_item.call(temp_offhand)
	snapshot.consumable = get_cloned_item.call(temp_consumable)
	var cloned_consumables: Array[ItemData] = []
	for item_data in temp_consumable_list:
		var clone = get_cloned_item.call(item_data)
		if clone:
			cloned_consumables.append(clone)
	snapshot.consumable_list = cloned_consumables
	
	var cloned_chests: Dictionary[String, Array] = {}
	for chest_id in save_file_resource.chest_items:
		var chest_array = save_file_resource.chest_items[chest_id]
		var cloned_chest_array = []
		for item_data in chest_array:
			if item_data:
				cloned_chest_array.append(item_data.duplicate(true))
		cloned_chests[chest_id] = cloned_chest_array
	snapshot.chest_items = cloned_chests
	
	current_savemanager_task_id = SaveFileManager.save_game(snapshot)

#func _save_multithreaded():
	#if CombatManager.is_in_combat():
		#return
	#if current_savemanager_task_id:
		#if not WorkerThreadPool.is_task_completed(current_savemanager_task_id):
			#return
	#if not save_file_resource:
		#save_file_resource = SaveFileManager.load_savefile(SaveFileManager.current_savefile_id)
	#if not save_file_resource:
		#push_error("Savefile Resource not found while saving")
		#return
	#if not player:
		#player = get_tree().get_first_node_in_group("Player")
	#if not player:
		#push_error("Player not found while saving")
		#return
	#if not player.is_on_floor():
		#return
	#save_file_resource.health = player.HEALTH
	#save_file_resource.stamina = player.STAMINA
	#save_file_resource.mana = player.MANA
	#save_file_resource.position = player.global_position
	#save_file_resource.rotation = player.global_rotation
	##save_file_resource.spirit = player.spirit
	#
	#_save_dead_enemies()
	#_save_chests()
	#get_items_from_inventory.emit()
	#
	#save_file_resource.player_items = temp_inventory
	#save_file_resource.head = temp_head
	#save_file_resource.body = temp_body
	#save_file_resource.boots = temp_boots
	#save_file_resource.mainhand = temp_mainhand
	#save_file_resource.offhand = temp_offhand
	#save_file_resource.consumable = temp_consumable
	#save_file_resource.consumable_list = temp_consumable_list
	#
	#save_file_resource.last_played_date = Time.get_datetime_string_from_system(false, true)
	#
	#current_savemanager_task_id = SaveFileManager.save_game(save_file_resource.duplicate(true))

func update_savefile_items(inventory: Array, head: Item, body: Item, boots: Item, mainhand: Item, offhand: Item, consumable: Item, consumable_list: Array):
	temp_inventory.assign(inventory.map(get_itemdata))
	temp_head = get_itemdata(head)
	temp_body = get_itemdata(body)
	temp_boots = get_itemdata(boots)
	temp_mainhand = get_itemdata(mainhand)
	temp_offhand = get_itemdata(offhand)
	temp_consumable = get_itemdata(consumable)
	temp_consumable_list.assign(consumable_list.map(get_itemdata))
	#_save()

func get_player_name() -> String:
	if not save_file_resource:
		save_file_resource = SaveFileManager.load_savefile(SaveFileManager.current_savefile_id)
	return save_file_resource.character_name

func get_itemdata(item: Item) -> ItemData:
	if item:
		return item.data
	return null

func _save_everything():
	_save()

func start():
	if not save_file_resource:
		save_file_resource = SaveFileManager.load_savefile(SaveFileManager.current_savefile_id)
	basic_data_timer.start()

func stop():
	basic_data_timer.stop()

func _basic_timer_timeout() -> void:
	if CombatManager.is_in_combat():
		return
	
	_save()

func save_game() -> void:
	_save()

func get_player_data() -> Dictionary:
	if not save_file_resource:
		save_file_resource = SaveFileManager.load_savefile(SaveFileManager.current_savefile_id)
	return {
		"HEALTH": save_file_resource.health,
		"STAMINA": save_file_resource.stamina,
		"MANA": save_file_resource.mana,
		"global_position": save_file_resource.position,
		"global_rotation": save_file_resource.rotation,
	#save_file_resource.spirit = player.spirit
	}

func get_current_playeritems() -> Dictionary:
	if not save_file_resource:
		save_file_resource = SaveFileManager.load_savefile(SaveFileManager.current_savefile_id)
	return {
		"inventory": save_file_resource.player_items,
		"head": save_file_resource.head,
		"body": save_file_resource.body,
		"boots": save_file_resource.boots,
		"mainhand": save_file_resource.mainhand,
		"offhand": save_file_resource.offhand,
		"consumable": save_file_resource.consumable,
		"consumable_list": save_file_resource.consumable_list,
	}

func load_mobspawn_data() -> Dictionary:
	if not save_file_resource:
		save_file_resource = SaveFileManager.load_savefile(SaveFileManager.current_savefile_id)
	return save_file_resource.dead_mobs

func load_world_event_data() -> Dictionary:
	if not save_file_resource:
		save_file_resource = SaveFileManager.load_savefile(SaveFileManager.current_savefile_id)
	return save_file_resource.world_events

func load_chest_data() -> Dictionary:
	if not save_file_resource:
		save_file_resource = SaveFileManager.load_savefile(SaveFileManager.current_savefile_id)
	return save_file_resource.chest_items

# worldloot / bossdrop
func items_received():
	pass

func _save_dead_enemies():
	var mobspawn_dict: Dictionary[String, bool] = {}
	var mobspawns: Array = get_tree().get_nodes_in_group("MobSpawn")
	for spawn in mobspawns:
		if spawn.is_my_mob_dead:
			#print(spawn.spawn_id)
			mobspawn_dict[spawn.spawn_id] = true
	save_file_resource.dead_mobs = mobspawn_dict

func _save_chests():
	var chest_dict: Dictionary[String, Array] = {}
	var chests: Array = get_tree().get_nodes_in_group("Chest")
	for chest in chests:
		if chest.item_container.items.is_empty():
			continue
		chest_dict[chest.chest_id] = chest.item_container.items.map(get_itemdata)
	save_file_resource.chest_items = chest_dict 

func _save_world_events() -> void:
	var event_dict: Dictionary[String, bool] = {}
	var events: Array = get_tree().get_nodes_in_group("WorldEvent")
	for event in events:
		if event.world_event_hash == "":
			continue
		if event.event == false:
			continue
		event_dict[event.world_event_hash] = true
	save_file_resource.world_events = event_dict
	

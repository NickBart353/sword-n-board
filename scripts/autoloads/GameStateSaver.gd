extends Node

#signal has_equipment_changed

var basic_data_timer: Timer
var inventory_data_timer: Timer

var objects_to_persist: Array
var object_data: Dictionary = {}

var player: Player
var basic_player_data: BasicPlayerData
var advanced_player_data: AdvancedPlayerData
var player_item_dict: Dictionary = {}
var chest_dict: Dictionary = {}

#thread ids
var current_player_item_thread_task_id: int
var current_chest_thread_task_id: int
var current_item_task_id: int

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	basic_player_data = BasicPlayerData.new()
	
	basic_data_timer = Timer.new()
	basic_data_timer.autostart = false
	basic_data_timer.wait_time = 10

	inventory_data_timer = Timer.new()
	inventory_data_timer.autostart = false
	inventory_data_timer.wait_time = 3
	inventory_data_timer.one_shot = true
	
	if not basic_data_timer.timeout.is_connected(_basic_timer_timeout):
		basic_data_timer.timeout.connect(_basic_timer_timeout)
	add_child(basic_data_timer)
	if not inventory_data_timer.timeout.is_connected(_inventory_timer_timeout):
		inventory_data_timer.timeout.connect(_inventory_timer_timeout)
	add_child(inventory_data_timer)

func start():
	basic_data_timer.start()

func _basic_timer_timeout() -> void:
	_save_basic_player_data()

func _inventory_timer_timeout():
	inventory_updated()

func _save_basic_player_data():
	if not player:
		player = get_tree().get_first_node_in_group("Player")
	basic_player_data.health = player.HEALTH
	basic_player_data.stamina = player.STAMINA
	basic_player_data.mana = player.MANA
	basic_player_data.position = player.global_position
	basic_player_data.rotation = player.global_rotation
	basic_player_data.spirit = 0
	DataManager.save_basic_player_data(basic_player_data)

func start_inventory_timer(inventory: Array, head: Item, body: Item, boots: Item, mainhand: Item, offhand: Item, consumable: Item, consumable_list: Array):
	inventory_data_timer.start()

	player_item_dict["head"] = head
	player_item_dict["body"] = body
	player_item_dict["boots"] = boots
	player_item_dict["mainhand"] = mainhand
	player_item_dict["offhand"] = offhand
	player_item_dict["equipped_consumable_list"] = consumable_list
	player_item_dict["equipped_consumable"] = consumable
	player_item_dict["inventory"] = inventory

# open inventory and change equipment - loot items from chest / lootbags - consume items - upgraded items from blacksmith / bought items from vendor
func inventory_updated():
	if current_item_task_id:
		if not WorkerThreadPool.is_task_completed(current_item_task_id): 
			return
	_dirty_chest_check()
	var prepared_item_list: Array = []
	if player_item_dict["head"]:
		append_head(player_item_dict["head"], prepared_item_list)
	if player_item_dict["body"]:
		append_body(player_item_dict["body"], prepared_item_list)
	if player_item_dict["boots"]:
		append_boots(player_item_dict["boots"], prepared_item_list)
	if player_item_dict["mainhand"]:
		append_mainhand(player_item_dict["mainhand"], prepared_item_list)
	if player_item_dict["offhand"]:
		append_offhand(player_item_dict["offhand"], prepared_item_list)
	if player_item_dict["equipped_consumable"]:
		append_main_consumable(player_item_dict["equipped_consumable"], prepared_item_list)
	
	for consumable in player_item_dict["equipped_consumable_list"]:
		append_consumable(consumable, prepared_item_list)
	
	for item in player_item_dict["inventory"]:
		if item:
			if item.data is WeaponData:
				append_other_weapon(item, prepared_item_list)
			else:
				append_other(item, prepared_item_list)
	
	for chest_id in chest_dict:
		for item in chest_dict[chest_id]:
			if item.data is WeaponData:
				append_other_weapon(item, prepared_item_list)
			else:
				append_other(item, prepared_item_list)
	
	current_item_task_id = DataManager.update_chest_and_items(prepared_item_list)

# worldloot / bossdrop
func items_received():
	pass

func _get_proper_id(item: Item) -> String:
	if not item:
		return ""
	return item.data.unique_id if item.data.unique_id else item.data.item_id

func _dirty_chest_check():
	if current_chest_thread_task_id:
		if not WorkerThreadPool.is_task_completed(current_chest_thread_task_id): 
			return
	
	var chests: Array = get_tree().get_nodes_in_group("Chest")
	var dirty_chests: Array = []
	for chest in chests:
		if chest.is_dirty:
			dirty_chests.append(chest)
	if dirty_chests.is_empty():
		return
	
	for chest in dirty_chests:
		#chest_dict[chest.chest_id] = chest.item_container.items.map(func(item): return item.data.item_id)
		chest_dict[chest.chest_id] = chest.item_container.items
	
func append_head(item: Item, array: Array):
	array.append({"item_id": item.data.item_id, "quantity": item.data.stack_size, "equipped": 1, "upgrade_level": item.data.upgrade_level, "upgrade_type": item.data.uprade_type})

func append_body(item: Item, array: Array):
	array.append({"item_id": item.data.item_id, "quantity": item.data.stack_size, "equipped": 2, "upgrade_level": item.data.upgrade_level, "upgrade_type": item.data.uprade_type})

func append_boots(item: Item, array: Array):
	array.append({"item_id": item.data.item_id, "quantity": item.data.stack_size, "equipped": 3, "upgrade_level": item.data.upgrade_level, "upgrade_type": item.data.uprade_type})

func append_mainhand(item: Item, array: Array):
	array.append({"item_id": item.data.item_id, "quantity": item.data.stack_size, "equipped": 4, "upgrade_level": item.data.upgrade_level, "upgrade_type": item.data.uprade_type})

func append_offhand(item: Item, array: Array):
	array.append({"item_id": item.data.item_id, "quantity": item.data.stack_size, "equipped": 5, "upgrade_level": item.data.upgrade_level, "upgrade_type": item.data.uprade_type})

func append_main_consumable(item: Item, array: Array):
	array.append({"item_id": item.data.item_id, "quantity": item.data.stack_size, "equipped": 6})

func append_consumable(item: Item, array: Array):
	array.append({"item_id": item.data.item_id, "quantity": item.data.stack_size, "equipped": 7})

func append_other(item: Item, array: Array, chest_id: String = ""):
	if chest_id:
		array.append({"item_id": item.data.item_id, "quantity": item.data.stack_size, "equipped": 0, "storage_id": chest_id})
	else:
		array.append({"item_id": item.data.item_id, "quantity": item.data.stack_size, "equipped": 0})

func append_other_weapon(item: Item, array: Array, chest_id: String = ""):
	if chest_id:
		array.append({"item_id": item.data.item_id, "quantity": item.data.stack_size, "equipped": 0, "upgrade_level": item.data.upgrade_level, "upgrade_type": item.data.uprade_type, "storage_id": chest_id})
	else:
		array.append({"item_id": item.data.item_id, "quantity": item.data.stack_size, "equipped": 0, "upgrade_level": item.data.upgrade_level, "upgrade_type": item.data.uprade_type})
	

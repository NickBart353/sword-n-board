extends Node

signal has_equipment_changed

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
	#_dirty_chest_check()
	#has_equipment_changed.emit()

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
	var consumable_list_ids: Array[String] = []
	for item in consumable_list:
		consumable_list_ids.append(item.data.item_id)
	
	var inventory_dict: Dictionary[String, int] = {}
	for item in inventory:
		inventory_dict[_get_proper_id(item)] = item.data.stack_size
	
	player_item_dict["head"] = _get_proper_id(head)
	player_item_dict["body"] = _get_proper_id(body)
	player_item_dict["boots"] = _get_proper_id(boots)
	player_item_dict["mainhand"] = _get_proper_id(mainhand)
	player_item_dict["offhand"] = _get_proper_id(offhand)
	player_item_dict["equipped_consumable_list"] = consumable_list_ids
	player_item_dict["equipped_consumable"] = _get_proper_id(consumable)
	player_item_dict["inventory"] = inventory_dict

# open inventory and change equipment - loot items from chest / lootbags - consume items - upgraded items from blacksmith / bought items from vendor
func inventory_updated():
	if current_player_item_thread_task_id:
		if not WorkerThreadPool.is_task_completed(current_player_item_thread_task_id): 
			return
	_dirty_chest_check()
	
	#current_player_item_thread_task_id = DataManager.save_player_items(player_item_dict.duplicate(true))
	#current_chest_thread_task_id = DataManager.update_chests(chest_dict.duplicate(true))
	var current_item_task_id: int = DataManager.update_chest_and_items(player_item_dict, chest_dict)

# after looting chests they update theselves
func chest_updated(chest_id: String, chest_inventory: Array[Item]):
	pass

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
		chest_dict[chest.chest_id] = chest.item_container.items.map(func(item): return item.data.item_id)
	

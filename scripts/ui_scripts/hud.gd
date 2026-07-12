extends Control

@onready var health_bar: ProgressBar = $PlayerResourceContainer/HealthMargin/HealthBar
@onready var stamina_bar: ProgressBar = $PlayerResourceContainer/StaminaMargin/StaminaBar
@onready var mana_bar: ProgressBar = $PlayerResourceContainer/ManaMargin/ManaBar

@onready var consumable_display: GridContainer = $ConsumablePanel/ConsumableMargin/ConsumableDisplay
@onready var mainhand_display: GridContainer = $MainhandPanel/MainhandMargin/MainhandDisplay
@onready var offhand_display: GridContainer = $OffhandPanel/OffhandMargin/OffhandDisplay

@onready var enemy_healthbar_container: VBoxContainer = $EnemyHealthbarContainer
@onready var enemy_healthbar: ProgressBar = $EnemyHealthbarContainer/_healthbar/EnemyHealthbar
@onready var enemy_name_label: Label = $EnemyHealthbarContainer/_label/EnemyName
@onready var enemy_healthbar_timer: Timer = $EnemyHealthbarContainer/EnemyHealthbarTimer

@export var display_item: PackedScene

var player_consumables: Array = []
var current_consumable_index: int
var current_consumable: Item
var current_enemy: Enemy
var last_enemy: Enemy

func _ready() -> void:
	UiController.set_player_consumables.connect(_set_player_consumables)
	UiController.player_consumed_item.connect(_remove_player_consumable)
	UiController.new_mainhand.connect(_new_mainhand)
	UiController.new_offhand.connect(_new_offhand)
	UiController.updated_hud_healthbar.connect(_updated_hud_enemy_healthbar)
	UiController.loaded_consumable_set.connect(_loaded_consumable_set)
	
	enemy_healthbar_container.hide()

func update_health(health: float):
	health_bar.value = health

func update_stamina(stamina: float):
	stamina_bar.value = stamina

func update_mana(mana: float):
	mana_bar.value = mana

func _process(_delta: float) -> void:
	if not current_enemy and last_enemy:
		enemy_healthbar.value = last_enemy.health
	$Label.text = str(Engine.get_frames_per_second())

func rotate_consumable():
	if player_consumables.size() > 0:
		current_consumable_index += 1
		if current_consumable_index >= player_consumables.size():
			current_consumable_index = 0
		current_consumable = player_consumables[current_consumable_index]
		for child in consumable_display.get_children():
			if child.item.data.item_id == current_consumable.data.item_id:
				child.show()
			else:
				child.hide()
		_update_player_consumable()

func _set_player_consumables(consumables: Array, new_current_consumable: Item = null):
	if new_current_consumable:
		current_consumable = new_current_consumable
	if not current_consumable in consumables:
		current_consumable = null
		_update_player_consumable()
	player_consumables = consumables
	for child in consumable_display.get_children():
		child.queue_free()
	if player_consumables.size() > 0:
		if current_consumable_index > player_consumables.size() - 1:
			current_consumable_index = 0
		var consumable_counter: int = 0
		for item in player_consumables:
			var display_instance = display_item.instantiate()
			display_instance.set_data(item)
			consumable_display.add_child(display_instance)
			display_instance.name = item.data.item_name
			if consumable_counter != current_consumable_index: 
				display_instance.hide()
			else:
				current_consumable = item
				_update_player_consumable()
			consumable_counter += 1

func _remove_player_consumable(item: Item):
	if item.data.stackable:
		item.data.stack_size -= 1
		if item.data.stack_size <= 0:
			_remove(item)
		else:
			UiController.remove_consumable_from_inventory(item, true)
			for inventory_item in consumable_display.get_children():
				if inventory_item.item.data.item_id == item.data.item_id:
					inventory_item.set_data(item)
					break
			current_consumable = item
	else:
		_remove(item)
	_update_player_consumable()

func _remove(item : Item):
	UiController.remove_consumable_from_inventory(item, false)
	for inventory_item in consumable_display.get_children():
		if inventory_item.item.data.item_id == item.data.item_id:
			inventory_item.queue_free()
			break
	for consumable in player_consumables:
		if item.data.item_id == consumable.data.item_id:
			player_consumables.remove_at(player_consumables.find(consumable))
			break
	current_consumable = null
	rotate_consumable()

func _update_player_consumable():
	UiController.give_player_new_consumable(current_consumable)

func _new_mainhand(item: Item):
	for child in mainhand_display.get_children():
		child.queue_free()
	if item:
		var display_instance = display_item.instantiate()
		display_instance.set_data(item)
		mainhand_display.add_child(display_instance)
		display_instance.name = item.data.item_name

func _new_offhand(item: Item, two_handed_duplicate: bool):
	for child in offhand_display.get_children():
		child.queue_free()
	if item:
		var display_instance = display_item.instantiate()
		display_instance.set_data(item)
		offhand_display.add_child(display_instance)
		display_instance.name = item.data.item_name
		if two_handed_duplicate:
			display_instance.modulate = Color(1, 1, 1, 0.3)

func _updated_hud_enemy_healthbar(enemy: Enemy) -> void:
	current_enemy = enemy
	if current_enemy:
		enemy_healthbar.value = current_enemy.health
		enemy_healthbar.max_value = current_enemy.MAX_HEALTH
		enemy_name_label.text = current_enemy.display_name
		enemy_healthbar_container.show()
	else:
		if not enemy_healthbar_timer.time_left:
			last_enemy = enemy
			enemy_healthbar_timer.start()

func _on_enemy_healthbar_timer_timeout() -> void:
	if last_enemy == current_enemy:
		enemy_healthbar_container.hide()
		last_enemy = null
		current_enemy = null

func _loaded_consumable_set(loaded_consumable: Item):
	current_consumable_index = 0
	for item in player_consumables:
		if item.data.item_id == loaded_consumable.data.item_id:
			break
		current_consumable_index += 1
	for child in consumable_display.get_children():
		if child.item.data.item_id == loaded_consumable.data.item_id:
			child.show()
			current_consumable = loaded_consumable
			break
		else:
			child.hide()
	_update_player_consumable()

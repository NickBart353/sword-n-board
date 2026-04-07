extends Control

@onready var health_bar: ProgressBar = $PlayerResourceContainer/HealthMargin/HealthBar
@onready var stamina_bar: ProgressBar = $PlayerResourceContainer/StaminaMargin/StaminaBar
@onready var mana_bar: ProgressBar = $PlayerResourceContainer/ManaMargin/ManaBar

@onready var consumable_display: GridContainer = $PanelContainer/ConsumableDisplay

@export var temp_consumable_display: PackedScene

var player_consumables: Array = []
var current_consumable_index: int
var current_consumable: Item

func _ready() -> void:
	UiController.set_player_consumables.connect(_set_player_consumables)
	UiController.player_consumed_item.connect(_remove_player_consumable)

func update_health(health: float):
	health_bar.value = health

func update_stamina(stamina: float):
	stamina_bar.value = stamina

func update_mana(mana: float):
	mana_bar.value = mana

func rotate_consumable():
	if player_consumables.size() > 0:
		for child in consumable_display.get_children():
			child.hide()
		current_consumable_index += 1
		if current_consumable_index >= player_consumables.size():
			current_consumable_index = 0
		current_consumable = consumable_display.get_child(current_consumable_index).item
		consumable_display.get_child(current_consumable_index).show()
		_update_player_consumable()

func _set_player_consumables(consumables: Array):
	player_consumables = consumables
	for child in consumable_display.get_children():
		child.queue_free()
	if player_consumables.size() > 0:
		if current_consumable_index > player_consumables.size() - 1:
			current_consumable_index = 0
		var temp_consumable_counter: int = 0
		for item in player_consumables:
			var display_instance = temp_consumable_display.instantiate()
			display_instance.disabled = true
			display_instance.set_data(item)
			consumable_display.add_child(display_instance)
			display_instance.name = item.data.item_name
			if temp_consumable_counter != current_consumable_index: 
				display_instance.hide()
			else:
				current_consumable = item
				_update_player_consumable()
			temp_consumable_counter += 1

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
	#current_consumable_index -= 1
	#if current_consumable_index < 0:
		#current_consumable_index = 0
	rotate_consumable()

func _update_player_consumable():
	UiController.give_player_new_consumable(current_consumable)

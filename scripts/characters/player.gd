class_name Player
extends CharacterBody3D

signal open_inventory
signal open_pause_menu
signal spawn_projectile

@onready var input = $InputController
@onready var state_controller = $StateController
@onready var movement = $MovementController
@onready var ability = $AbilityController
@onready var animation = $AnimationController
@onready var head: Node3D = $Head
@onready var left_hand = $Head/FieldOfView/LeftHand
@onready var right_hand = $Head/FieldOfView/RightHand
@onready var consumable_slot = $Slots/Consumable
@onready var head_slot = $Slots/Head
@onready var body_slot = $Slots/Body
@onready var boots_slot = $Slots/Boots

@export var movement_speed = 4
@export var look_speed: float = 0.002

const MAX_HEALTH: int = 100
const MIN_HEALTH: int = 0

var primary_equipped: String = "None"
var secondary_equipped: String = "None"
var look_rotation : Vector2
var interacting_object
var last_hovered_object
var node_name
var menu_open = false
var HEALTH: int
var collision: bool = false

var items: Array = []
var head_item: Item
var body_item: Item
var boots_item: Item
var main_hand_item: Item
var off_hand_item: Item
var consumable_item: Item
var blocked_body: Node

func _ready() -> void:
	#floor_snap_length = 0.2
	_load_preset_items()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	HEALTH = MAX_HEALTH
	$CanvasLayer/RedBar/HealthBar.value = HEALTH
	look_rotation.y = rotation.y
	look_rotation.x = head.rotation.x
	$AbilityController/CastAttack.spawn_magic_projectile.connect(_spawn_projectile)
	$AbilityController/ShootAttack.spawn_projectile.connect(_spawn_projectile)
	$AbilityController/Block.blocked.connect(_blocked_attack)
	$AbilityController/Consume.consume_item.connect(_consume_item)
	$AbilityController/Consume.finished_consuming.connect(_remove_consumable)

func _physics_process(delta: float) -> void:
	input.get_input(delta)
	movement.apply_movement(input, state_controller, delta)
	ability.apply_abilities(input, state_controller, movement, delta)
	animation.apply_animations(input, state_controller, movement, ability, delta)
	
	if not state_controller.current_state == StateController.STATE.CONSUMING:
		interact_with_object()
		_open_inventory()
	move_and_slide()

func interact_with_object():
	interacting_object = $"Head/FieldOfView/RayCast3D".get_collider()
	if (not interacting_object and last_hovered_object) or (last_hovered_object and interacting_object != last_hovered_object):
		last_hovered_object.get_node(node_name).un_hover()
		last_hovered_object = null
		node_name = ""
	if interacting_object:
		if interacting_object.get_node_or_null("Interactable") != null:
			node_name = "Interactable"
		elif interacting_object.get_node_or_null("ItemContainer") != null:
			node_name = "ItemContainer"
		else:
			return
		last_hovered_object = interacting_object
		interacting_object.get_node(node_name).hover()
		if input.interact:
			interacting_object.get_node(node_name).interact()

func _open_inventory():
	if input.inventory:
		open_inventory.emit(items, head_item, body_item, boots_item, main_hand_item, off_hand_item, consumable_item)

func get_equipped_primary():
	var weapon: Array = $Head/FieldOfView/RightHand.get_children()
	if weapon:
		return weapon[0]
	return null

func get_equipped_secondary():
	var offhand: Array = $Head/FieldOfView/LeftHand.get_children()
	if offhand:
		return offhand[0]
	return null

func get_equipped_consumable():
	var consumable: Array = $Slots/Consumable.get_children()
	if consumable:
		return consumable[0]
	return null

func update_items(player_items, new_head_item: Item, new_body_item: Item, new_boots_item: Item, new_main_hand_item: Item, new_off_hand_item: Item, new_consumable_item: Item):
	_reset_abilities()
	var two_handed: bool = false
	if new_main_hand_item:
		two_handed = ((new_main_hand_item == new_off_hand_item) and new_main_hand_item.data.two_handed)
	
	items = player_items
	head_item = _reequip_slot(head_item, new_head_item, head_slot)
	body_item = _reequip_slot(body_item, new_body_item, body_slot)
	boots_item = _reequip_slot(boots_item, new_boots_item, boots_slot)
	consumable_item = _reequip_slot(consumable_item, new_consumable_item, consumable_slot)
	
	if two_handed:
		if main_hand_item != new_main_hand_item:
			main_hand_item = new_main_hand_item
			off_hand_item = new_off_hand_item
			_clear_equip_slot(right_hand)
			_clear_equip_slot(left_hand)
			var item_instance = ItemGenerator.generate_item(main_hand_item.data)
			if item_instance:
				if item_instance is Node:
					right_hand.add_child(item_instance, true)
				elif item_instance is Dictionary:
					for item_slot in item_instance:
						match item_slot:
							ItemGenerator.SLOTS.MAIN_HAND:
								right_hand.add_child(item_instance[item_slot], true)
							ItemGenerator.SLOTS.OFF_HAND:
								left_hand.add_child(item_instance[item_slot], true)
	else:
		main_hand_item = _reequip_slot(main_hand_item, new_main_hand_item, right_hand)
		off_hand_item = _reequip_slot(off_hand_item, new_off_hand_item, left_hand)

func _reequip_slot(old, new, slot):
	if old != new:
		old = new
		_clear_equip_slot(slot)
		if old:
			var item_instance = ItemGenerator.generate_item(old.data)
			if item_instance:
				slot.add_child(item_instance)
	return old

func _clear_equip_slot(slot: Node):
	for child in slot.get_children():
		child.queue_free()

func _reset_abilities():
	for ability_instance in ability.get_children():
		ability_instance.reset()

func _consume_item(property: String, property_type: Potion.PROPERTY_TYPE, amount: float):
	if property in self:
		match property_type:
			Potion.PROPERTY_TYPE.INCREASE:
				if self.has_method("update_{0}".format([property])):
					call("update_{0}".format([property]), amount)
			Potion.PROPERTY_TYPE.DECREASE:
				if self.has_method("update_{0}".format([property])):
					call("update_{0}".format([property]), -amount)
			_:
				print("not implemented yet...")

func _remove_consumable():
	consumable_item = _reequip_slot(consumable_item, null, consumable_slot)

func _unhandled_input(event: InputEvent) -> void:	
	if event is InputEventMouseMotion:
		look_rotation.x -= event.relative.y * look_speed
		look_rotation.x = clamp(look_rotation.x, deg_to_rad(-85), deg_to_rad(85))
		look_rotation.y -= event.relative.x * look_speed
		transform.basis = Basis()
		rotate_y(look_rotation.y)
		head.transform.basis = Basis()
		head.rotate_x(look_rotation.x)
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if Input.is_key_pressed(KEY_ESCAPE):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func take_damage(damage, body: Node):
	if body == blocked_body and blocked_body != null:
		blocked_body = null
		return
	update_HEALTH(-damage)

func update_HEALTH(amount: float):
	HEALTH += amount
	if HEALTH <= MIN_HEALTH:
		HEALTH = MIN_HEALTH
		_die()
	if HEALTH >= MAX_HEALTH:
		HEALTH = MAX_HEALTH
	$CanvasLayer/RedBar/HealthBar.value = HEALTH

func _blocked_attack(body: Node):
	blocked_body = body

func get_looking_direction() -> Vector3:
	#return $Head/FieldOfView.get_global_transform().basis.z
	var direction = $Head/FieldOfView.get_global_transform().basis.z
	direction.z *= -1
	direction.x *= -1
	direction.y *= -1
	direction = direction.normalized()
	return direction

func get_camera_transform() -> Transform3D:
	return $Head/FieldOfView.global_transform

func _spawn_projectile(projectile: Node, spawn_position: Vector3, direction: Vector3, proj_transform: Transform3D, direction_flag: bool = false):
	spawn_projectile.emit(projectile, spawn_position, direction, proj_transform, direction_flag)

func _load_preset_items():
	var sword: Control = preload("res://scenes/ui_scenes/item.tscn").instantiate()
	sword.data = ItemManager.ITEMS["iron_sword"]
	items.append(sword)
	var book: Control = preload("res://scenes/ui_scenes/item.tscn").instantiate()
	book.data = ItemManager.ITEMS["magic_tome"]
	items.append(book)
	var shield: Control = preload("res://scenes/ui_scenes/item.tscn").instantiate()
	shield.data = ItemManager.ITEMS["wooden_shield"]
	items.append(shield)
	var bow: Control = preload("res://scenes/ui_scenes/item.tscn").instantiate()
	bow.data = ItemManager.ITEMS["wooden_bow"]
	items.append(bow)
	var torch: Control = preload("res://scenes/ui_scenes/item.tscn").instantiate()
	torch.data = ItemManager.ITEMS["torch"]
	items.append(torch)
	var potion: Control = preload("res://scenes/ui_scenes/item.tscn").instantiate()
	potion.data = ItemManager.ITEMS["health_potion"]
	items.append(potion)

func _die():
	print("game over")

	#if freeflying:
		#var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		#var motion := (head.global_basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		#motion *= freefly_speed * delta
		#move_and_collide(motion)
		#return

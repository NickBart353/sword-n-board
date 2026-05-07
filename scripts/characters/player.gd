class_name Player
extends CharacterBody3D

signal open_inventory
signal open_pause_menu
signal spawn_projectile

@onready var input: Node = $InputController
@onready var state_controller: Node = $StateController
@onready var movement: Node = $MovementController
@onready var ability: Node = $AbilityController
@onready var animation: Node = $AnimationController
@onready var new_animation: Node = $AnimationControllerNew
@onready var audio: Node = $AudioController
@onready var ground_raycast = $GroundRayCasts
@onready var player_camera = $"Player - Kopie/IKMarkers/Torso/Head/FieldOfView"
@onready var player_interactor = $"Player - Kopie/IKMarkers/Torso/Head/FieldOfView/RayCast3D"
@onready var consumable_slot = $Slots/Consumable
@onready var head_slot = $Slots/Head
@onready var body_slot = $Slots/Body
@onready var boots_slot = $Slots/Boots
#@onready var healthbar = $CanvasLayer/Control/RedBar/HealthBar
@onready var stamina_regeneration_delay: Timer = $Timers/StaminaRegenerationDelay
@onready var slow_stamina_regeneration_delay: Timer = $Timers/SlowStaminaRegenerationDelay
@onready var timers: Node3D = $Timers

#@onready var mainhand: Marker3D = $"Player - Kopie/IKMarkers/Torso/Head/FieldOfView/Weapons/Mainhand"
#@onready var offhand: Marker3D = $"Player - Kopie/IKMarkers/Torso/Head/FieldOfView/Weapons/Offhand"
#@onready var twohand: Marker3D = $"Player - Kopie/IKMarkers/Torso/Head/FieldOfView/Weapons/Twohand"

@onready var mainhand: Marker3D = $"Player - Kopie/Weapons/Mainhand"
@onready var offhand: Marker3D = $"Player - Kopie/Weapons/Offhand"
@onready var twohand: Marker3D = $"Player - Kopie/Weapons/Twohand"

@onready var arm_left: TwoBoneIK3D = $"Player - Kopie/Armature/Skeleton3D/ArmLeft"
@onready var arm_right: TwoBoneIK3D = $"Player - Kopie/Armature/Skeleton3D/ArmRight"
@onready var finger_left: TwoBoneIK3D = $"Player - Kopie/Armature/Skeleton3D/FingerLeft"
@onready var finger_right: TwoBoneIK3D = $"Player - Kopie/Armature/Skeleton3D/FingerRight"
@onready var thumb_left: TwoBoneIK3D = $"Player - Kopie/Armature/Skeleton3D/ThumbLeft"
@onready var thumb_right: TwoBoneIK3D = $"Player - Kopie/Armature/Skeleton3D/ThumbRight"

#@onready var hand_right: CopyTransformModifier3D = $"Player - Kopie/Armature/Skeleton3D/HandRight"
#@onready var hand_left: CopyTransformModifier3D = $"Player - Kopie/Armature/Skeleton3D/HandLeft"

@export var movement_speed = 4
@export var look_speed: float = 0.002
@export_range(0.0, 100.0) var stamina_regeneration_speed: float = 10.0
@export_range(0.0, 100.0) var mana_regeneration_speed: float = 10.0

const MAX_HEALTH: int = 100
const MIN_HEALTH: int = 0
const MAX_STAMINA: int = 100
const MIN_STAMINA: float = 0.0
const MAX_MANA: float = 100.0
const MIN_MANA: float = 0.0

var primary_equipped: String = "None"
var secondary_equipped: String = "None"
var look_rotation : Vector2
var interacting_object
var last_hovered_object
var node_name
var menu_open = false
var collision: bool = false

var saved_stamina_regeneration_speed: float

var HEALTH: float
var STAMINA: float
var MANA: float

#var items: Array = []
#var consumables: Array = []
var head_item: Item
var body_item: Item
var boots_item: Item
var main_hand_item: Item
var off_hand_item: Item
var consumable_item: Item

var blocked_body: Node

var rotation_modifier: float = 1

func _ready() -> void:
	###DEBUG
	for child in mainhand.get_children():
		child.queue_free()
	for child in offhand.get_children():
		child.queue_free()
	for child in twohand.get_children():
		child.queue_free()
	for child in self.find_children("*"):
		if child is Node3D:
			child.show()
	$AnimationTreeNew.active = true
	###DEBUG END
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	HEALTH = MAX_HEALTH
	STAMINA = MAX_STAMINA
	MANA = MAX_MANA
	UiController.update_healthbar(HEALTH)
	UiController.update_staminabar(STAMINA)
	UiController.update_manabar(MANA)
	UiController.new_player_items.connect(new_player_items)
	UiController.new_consumable.connect(_new_consumable)
	look_rotation.y = rotation.y
	look_rotation.x = player_camera.rotation.x
	movement.update_rotation_modifier.connect(_update_rotation_modifier)
	$AbilityController/CastAttack.spawn_magic_projectile.connect(_spawn_projectile)
	$AbilityController/ShootAttack.spawn_projectile.connect(_spawn_projectile)
	$AbilityController/Block.blocked.connect(_blocked_attack)
	$AbilityController/Consume.consume_item.connect(_consume_item)
	$AbilityController/Consume.finished_consuming.connect(_remove_consumable)
	_check_unequipped_slots()

func _update_rotation_modifier(new_rotation_modifier: float) -> void:
	rotation_modifier = new_rotation_modifier

func _process(delta: float) -> void:
	if not stamina_regeneration_delay.time_left and not slow_stamina_regeneration_delay.time_left and not STAMINA == MAX_STAMINA:
		STAMINA += stamina_regeneration_speed * delta
		if STAMINA > MAX_STAMINA:
			STAMINA = MAX_STAMINA
		UiController.update_staminabar(STAMINA)
	if not MANA == MAX_MANA:
		MANA += mana_regeneration_speed * delta
		if MANA > MAX_MANA:
			MANA = MAX_MANA
		UiController.update_manabar(MANA)

func _physics_process(delta: float) -> void:
	input.get_input(delta)
	movement.apply_movement(input, state_controller, ability, delta)
	ability.apply_abilities(input, state_controller, movement, delta)
	#animation.apply_animations(input, state_controller, movement, ability, delta)
	new_animation.apply_animations(input, state_controller, movement, ability, delta)
	audio.apply_audio(state_controller, movement, ability)
	
	if not state_controller.is_player_busy():
		interact_with_object()
		#_open_inventory()
	move_and_slide()

func interact_with_object():
	interacting_object = player_interactor.get_collider()
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

#func _open_inventory():
	#if input.inventory:
		#open_inventory.emit(items, head_item, body_item, boots_item, main_hand_item, off_hand_item, consumable_item)

func get_equipped_consumable():
	var consumable: Array = $Slots/Consumable.get_children()
	if consumable:
		return consumable[0]
	return null

##func update_items(player_items, new_head_item: Item, new_body_item: Item, new_boots_item: Item, new_main_hand_item: Item, new_off_hand_item: Item, new_consumable_item: Item):
#func update_items(new_head_item: Item, new_body_item: Item, new_boots_item: Item, new_main_hand_item: Item, new_off_hand_item: Item, new_consumable_item: Item):
	#_reset_abilities()
	#var two_handed: bool = new_main_hand_item.data.two_handed
	#
	##items = player_items
	#head_item = _reequip_slot(head_item, new_head_item, head_slot)
	#body_item = _reequip_slot(body_item, new_body_item, body_slot)
	#boots_item = _reequip_slot(boots_item, new_boots_item, boots_slot)
	#consumable_item = _reequip_slot(consumable_item, new_consumable_item, consumable_slot)
	#
	#if two_handed:
		#if main_hand_item != new_main_hand_item:
			#main_hand_item = new_main_hand_item
			#off_hand_item = new_off_hand_item
			#_clear_equip_slot(right_hand)
			#_clear_equip_slot(left_hand)
			#var item_instance = ItemGenerator.generate_item(main_hand_item.data)
			#if item_instance:
				#if item_instance is Node:
					#right_hand.add_child(item_instance, true)
				#elif item_instance is Dictionary:
					#for item_slot in item_instance:
						#match item_slot:
							#ItemGenerator.SLOTS.MAIN_HAND:
								#right_hand.add_child(item_instance[item_slot], true)
							#ItemGenerator.SLOTS.OFF_HAND:
								#left_hand.add_child(item_instance[item_slot], true)
	#else:
		#main_hand_item = _reequip_slot(main_hand_item, new_main_hand_item, right_hand)
		#off_hand_item = _reequip_slot(off_hand_item, new_off_hand_item, left_hand)

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
		slot.remove_child(child)
		child.queue_free()

func _reset_abilities():
	for ability_instance in ability.get_children():
		ability_instance.reset()

func new_player_items(player_helmet: Item, player_body: Item, player_boots: Item, player_mainhand: Item, player_offhand: Item) -> void:
	_reset_abilities()
	var two_handed: bool = false
	if player_mainhand:
		two_handed = player_mainhand.data.two_handed
	
	head_item = _reequip_slot(head_item, player_helmet, head_slot)
	body_item = _reequip_slot(body_item, player_body, body_slot)
	boots_item = _reequip_slot(boots_item, player_boots, boots_slot)
	
	if two_handed:
		if main_hand_item != player_mainhand:
			main_hand_item = player_mainhand
			off_hand_item = player_offhand
			_clear_equip_slot(mainhand)
			_clear_equip_slot(offhand)
			var item_instance: Weapon = ItemGenerator.generate_item(main_hand_item.data)
			if item_instance:
				twohand.add_child(item_instance)
				item_instance.update_markers("")
				var marker_dictionary: Dictionary = item_instance.get_markers()
				arm_right.set_target_node(0, marker_dictionary.get("R").get("Hand").get_path())
				finger_right.set_target_node(0, marker_dictionary.get("R").get("Finger").get_path())
				thumb_right.set_target_node(0, marker_dictionary.get("R").get("Thumb").get_path())
				finger_right.set_pole_node(0, marker_dictionary.get("R").get("FingerPole").get_path())
				thumb_right.set_pole_node(0, marker_dictionary.get("R").get("ThumbPole").get_path())
				
				arm_left.set_target_node(0, marker_dictionary.get("L").get("Hand").get_path())
				finger_left.set_target_node(0, marker_dictionary.get("L").get("Finger").get_path())
				thumb_left.set_target_node(0, marker_dictionary.get("L").get("Thumb").get_path())
				finger_left.set_pole_node(0, marker_dictionary.get("L").get("FingerPole").get_path())
				thumb_left.set_pole_node(0, marker_dictionary.get("L").get("ThumbPole").get_path())
				
				new_animation.equipped_two_hand_weapon(item_instance.data.item_name.to_lower())
	
	else:
		_clear_equip_slot(twohand)
		main_hand_item = _reequip_mainhand(main_hand_item, player_mainhand, mainhand)
		off_hand_item = _reequip_offhand(off_hand_item, player_offhand, offhand)
	_set_weapons()

func _reequip_mainhand(old: Item, new: Item, slot):
	if old != new or (not new and not main_hand_item):
		old = new
		_clear_equip_slot(slot)
		var item_instance: Weapon
		var anim_name: String
		if not old:
			item_instance = ItemGenerator.generate_unarmed()
			anim_name = "fist"
		else:
			item_instance = ItemGenerator.generate_item(old.data)
			anim_name = item_instance.data.item_name.to_lower()
		if item_instance:
			slot.add_child(item_instance)
			item_instance.update_markers("R")
			var marker_dictionary: Dictionary = item_instance.get_markers()
			arm_right.set_target_node(0, marker_dictionary.get("Hand").get_path())
			finger_right.set_target_node(0, marker_dictionary.get("Finger").get_path())
			thumb_right.set_target_node(0, marker_dictionary.get("Thumb").get_path())
			finger_right.set_pole_node(0, marker_dictionary.get("FingerPole").get_path())
			thumb_right.set_pole_node(0, marker_dictionary.get("ThumbPole").get_path())
			
			new_animation.equpped_mainhand_weapon(anim_name)
	return old

func _reequip_offhand(old: Item, new: Item, slot):
	if old != new or (not old and not off_hand_item):
		old = new
		_clear_equip_slot(slot)
		var item_instance: Weapon
		var anim_name: String
		if not old:
			item_instance = ItemGenerator.generate_unarmed()
			anim_name = "fist"
		else:
			item_instance = ItemGenerator.generate_item(old.data)
			anim_name = item_instance.data.item_name.to_lower()
		if item_instance:
			slot.add_child(item_instance)
			item_instance.update_markers("L")
			var marker_dictionary: Dictionary = item_instance.get_markers()
			arm_left.set_target_node(0, marker_dictionary.get("Hand").get_path())
			finger_left.set_target_node(0, marker_dictionary.get("Finger").get_path())
			thumb_left.set_target_node(0, marker_dictionary.get("Thumb").get_path())
			finger_left.set_pole_node(0, marker_dictionary.get("FingerPole").get_path())
			thumb_left.set_pole_node(0, marker_dictionary.get("ThumbPole").get_path())
			
			new_animation.equpped_offhand_weapon(anim_name)
	return old

func _check_unequipped_slots():
	main_hand_item = _reequip_mainhand(main_hand_item, null, mainhand)
	off_hand_item = _reequip_offhand(off_hand_item, null, offhand)
	_set_weapons()

func _new_consumable(item: Item):
	consumable_item = _reequip_slot(consumable_item, item, consumable_slot)
	_set_weapons()

func _set_weapons():
	var main_slot: Node = get_equipped_weapon_from_slot(twohand) if get_equipped_weapon_from_slot(twohand) else get_equipped_weapon_from_slot(mainhand)
	var off_slot: Node = get_equipped_weapon_from_slot(twohand) if get_equipped_weapon_from_slot(twohand) else get_equipped_weapon_from_slot(offhand)
	
	print(main_slot)
	#for ability in ability:
	$AbilityController/Attack.set_item(main_slot)
	$AbilityController/CastAttack.set_item(main_slot)
	$AbilityController/ShootAttack.set_item(main_slot)
	$AbilityController/Block.set_item(off_slot)
	$AbilityController/Parry.set_item(off_slot)
	$AbilityController/Light.set_item(off_slot)
	$AbilityController/Consume.set_item(get_equipped_weapon_from_slot(consumable_slot))

func get_equipped_weapon_from_slot(slot: Marker3D):
	var children: Array = slot.get_children()
	if children and children.size() >= 1:
		return children[0]
	return null

func _consume_item(consumable: Node) -> void:
	#property: String, property_type: ConsumableData.PROPERTY_TYPE, amount: float, duration: float = -1.0):
	if consumable.property in self:
		match consumable.property_type:
			ConsumableData.PROPERTY_TYPE.INCREASE:
				if self.has_method("update_{0}".format([consumable.property])):
					call("update_{0}".format([consumable.property]), consumable.amount)
					if consumable.data.temporary:
						var timer_instance = Timer.new()
						timers.add_child(timer_instance)
						timer_instance.one_shot = true
						timer_instance.start(consumable.data.duration_seconds)
						var method_name = "reset_{0}".format([consumable.property])
						timer_instance.timeout.connect(Callable(self, method_name))
						timer_instance.timeout.connect(_on_buff_timeout.bind(timer_instance))
					
					#var heal_vfx = VfxManager.create_vfx_from_enum(VfxManager.VFX.HEAL_PARTICLES, global_position, true).instantiate()
					var consume_vfx = consumable.data.vfx.instantiate()
					add_child(consume_vfx)
					consume_vfx.play()
			ConsumableData.PROPERTY_TYPE.DECREASE:
				if self.has_method("update_{0}".format([consumable.property])):
					call("update_{0}".format([consumable.property]), -consumable.amount)
			_:
				print("not implemented yet...")

func _remove_consumable():
	UiController.consumed(consumable_item)

func _unhandled_input(event: InputEvent) -> void:
	if PlayerControls.input_blocked():
		return
	if event is InputEventMouseMotion:
		look_rotation.x -= event.relative.y * look_speed * PlayerControls.sensitivity
		look_rotation.x = clamp(look_rotation.x, deg_to_rad(-85), deg_to_rad(85))
		look_rotation.y -= event.relative.x * look_speed * PlayerControls.sensitivity * rotation_modifier
		transform.basis = Basis()
		rotate_y(look_rotation.y)
		player_camera.transform.basis = Basis()
		player_camera.rotate_x(look_rotation.x)
		player_camera.rotate_y(look_rotation.y)

func take_damage(damage, body: Node):
	if body == blocked_body and blocked_body != null:
		blocked_body = null
		if use_stamina($AbilityController/Block.base_block_cost * damage * 0.1):
			damage *= 0.2
		else:
			use_stamina(STAMINA)
			damage *= 3
	update_HEALTH(-damage)

func update_stamina_regeneration_speed(amount: float):
	saved_stamina_regeneration_speed = stamina_regeneration_speed
	stamina_regeneration_speed += amount

func reset_stamina_regeneration_speed():
	stamina_regeneration_speed = saved_stamina_regeneration_speed
	saved_stamina_regeneration_speed = 0

func update_MANA(amount: float):
	MANA += amount
	if MANA < MIN_MANA:
		MANA = MIN_MANA
	if MANA >= MAX_MANA:
		MANA = MAX_MANA
	UiController.update_manabar(MANA)

func update_HEALTH(amount: float):
	HEALTH += amount
	if HEALTH <= MIN_HEALTH:
		HEALTH = MIN_HEALTH
		_die()
	if HEALTH >= MAX_HEALTH:
		HEALTH = MAX_HEALTH
	UiController.update_healthbar(HEALTH)

func use_stamina(stamina_cost: float) -> bool:
	if STAMINA < 1:
		return false
	elif STAMINA - stamina_cost < MIN_STAMINA and not STAMINA < 1:
		STAMINA = 0
		slow_stamina_regeneration_delay.start()
		UiController.update_staminabar(STAMINA)
		return true
	else:
		STAMINA -= stamina_cost
		UiController.update_staminabar(STAMINA)
		stamina_regeneration_delay.start()
		return true

func use_mana(mana_cost: float) -> bool:
	if MANA - mana_cost < MIN_MANA:
		return false
	else:
		MANA -= mana_cost
		UiController.update_manabar(MANA)
		return true

func _blocked_attack(body: Node):
	blocked_body = body

func get_looking_direction() -> Vector3:
	#return $Head/FieldOfView.get_global_transform().basis.z
	var direction = player_camera.get_global_transform().basis.z
	direction.z *= -1
	direction.x *= -1
	direction.y *= -1
	direction = direction.normalized()
	return direction

func get_camera_transform() -> Transform3D:
	return player_camera.global_transform

func get_camera() -> Camera3D:
	return player_camera

func get_directional_raycasts() -> Node3D:
	return ground_raycast

func _spawn_projectile(projectile: Node, spawn_position: Vector3, direction: Vector3, proj_transform: Transform3D, direction_flag: bool = false):
	spawn_projectile.emit(projectile, spawn_position, direction, proj_transform, direction_flag)

#func _load_preset_items():
	#items = ItemManager.load_debug_items()
	#items.append_array(ItemManager.load_debug_items())
	#items.append_array(ItemManager.load_debug_items())

func _play_audio_fire_and_forget(resource: AudioStream, bus: AudioManager.BUS, offset: float = 0.0):
	AudioManager.play_audio_from_resource(resource, global_position, bus, offset)

func _on_buff_timeout(timer_ref: Timer):
	timer_ref.queue_free()

func _die():
	print("game over")

	#if freeflying:
		#var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		#var motion := (head.global_basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		#motion *= freefly_speed * delta
		#move_and_collide(motion)
		#return

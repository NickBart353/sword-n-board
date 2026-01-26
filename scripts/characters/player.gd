class_name Player
extends CharacterBody3D

const MAX_HEALTH: int = 100
const MIN_HEALTH: int = 100

var health: int = MAX_HEALTH

var mouse_captured : bool = false
var look_rotation : Vector2
var freeflying : bool = false
var blocking = false
var interacting_object
var last_hovered_object
var node_string: String = ""

var items: Array = []

signal open_inventory

@onready var head: Node3D = $Head
@onready var collider: CollisionShape3D = $CollisionShape3D

@export_group("Speeds")
@export var look_speed : float = 0.002
@export var base_speed : float = 5.0
@export var jump_velocity : float = 4
@export var sprint_speed : float = 10.0
@export var freefly_speed : float = 25.0
@export var speed: int = 4

func _ready() -> void:
	look_rotation.y = rotation.y
	look_rotation.x = head.rotation.x
	$CanvasLayer/RedBar/HealthBar.value = health

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		capture_mouse()
	if Input.is_key_pressed(KEY_ESCAPE):
		release_mouse()
	
	# Look around
	if mouse_captured and event is InputEventMouseMotion:
		rotate_look(event.relative)
	
	if Input.is_action_just_pressed("freefly"):
		if not freeflying:
			enable_freefly()
		else:
			disable_freefly()

func _physics_process(delta: float) -> void:
	if freeflying:
		var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		var motion := (head.global_basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		motion *= freefly_speed * delta
		move_and_collide(motion)
		return
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity
	
	var move_input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var move_dir := (transform.basis * Vector3(move_input_dir.x, 0, move_input_dir.y)).normalized()
	if move_dir:
		velocity.x = move_dir.x * speed
		velocity.z = move_dir.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
		
	if Input.is_action_just_pressed("attack"):
		_attack()
	
	if Input.is_action_just_pressed("Inventory"):
		open_inventory.emit(items)
	
	_interact_with_object()
	
	move_and_slide()

func capture_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	mouse_captured = true

func release_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	mouse_captured = false

func enable_freefly():
	collider.disabled = true
	freeflying = true
	velocity = Vector3.ZERO

func disable_freefly():
	collider.disabled = false
	freeflying = false

func rotate_look(rot_input : Vector2):
	look_rotation.x -= rot_input.y * look_speed
	look_rotation.x = clamp(look_rotation.x, deg_to_rad(-85), deg_to_rad(85))
	look_rotation.y -= rot_input.x * look_speed
	transform.basis = Basis()
	rotate_y(look_rotation.y)
	head.transform.basis = Basis()
	head.rotate_x(look_rotation.x)

func _attack():
	var weapon = $Head/FieldOfView/RightHand.get_child(0)
	weapon.play_animation()
	weapon.set_attacking(true)

func take_damage(damage, _body):
	if not blocking:
		health -= damage
	if health <= MIN_HEALTH:
		_die()
	$CanvasLayer/RedBar/HealthBar.value = health

func _die():
	print("game over")

func _interact_with_object():
	interacting_object = $Head/FieldOfView/RayCast3D.get_collider()
	if (not interacting_object and last_hovered_object) or (last_hovered_object and interacting_object != last_hovered_object):
		last_hovered_object.get_node(node_string).un_hover()
		last_hovered_object = null
		node_string = ""
	if interacting_object:
		if interacting_object.get_node_or_null("Interactable") != null:
			node_string = "Interactable"
		elif interacting_object.get_node_or_null("ItemContainer") != null:
			node_string = "ItemContainer"
		else:
			return
		last_hovered_object = interacting_object
		interacting_object.get_node(node_string).hover()
		if Input.is_action_just_pressed("interact"):
			interacting_object.get_node(node_string).interact()

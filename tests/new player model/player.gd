extends CharacterBody3D

@onready var head: Node3D = $Head
@onready var left_foot: Marker3D = $BoneMarkers/LeftFoot
@onready var right_foot: Marker3D = $BoneMarkers/RightFoot

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

const left_foot_position = Vector3(0.138, 0, 0)
const right_foot_position = Vector3(-0.138, 0, 0)

const left_moving_foot_position = Vector3(0.138, -0.13, 0.445)
const right_moving_foot_position = Vector3(-0.138, -0.13, -0.445)

@export var look_speed: float = 0.002
@export var anim_tree: AnimationTree

var look_rotation : Vector2

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	anim_tree.active = true

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	
	anim_tree.set("parameters/Movement/blend_position", input_dir)
	if Input.is_action_just_pressed("primary"):
		anim_tree.set("parameters/Attack/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

	var direction := (transform.basis * Vector3(-input_dir.x, 0, -input_dir.y)).normalized()

	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	if input_dir:
		left_foot.position = left_foot.position.move_toward(left_moving_foot_position, delta)
		right_foot.position = right_foot.position.move_toward(right_moving_foot_position, delta)
	else:
		left_foot.position = left_foot.position.move_toward(left_foot_position, delta)
		right_foot.position = right_foot.position.move_toward(right_foot_position, delta)
	
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if PlayerControls.input_blocked():
		return

	if event is InputEventMouseMotion:
		look_rotation.x -= event.relative.y * look_speed * PlayerControls.sensitivity
		look_rotation.x = clamp(look_rotation.x, deg_to_rad(-85), deg_to_rad(85))
		look_rotation.y -= event.relative.x * look_speed * PlayerControls.sensitivity

		self.rotation.y = look_rotation.y + PI

		head.rotation = Vector3(look_rotation.x, PI, 0)

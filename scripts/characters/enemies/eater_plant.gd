extends Enemy

@onready var bombs: Node3D = $Bombs
@onready var tentacle_root_container: Node3D = $TentacleRoots

@export var POISON_BOMB_SCENE: PackedScene
@export var poison_blast_bullet_amount: int = 10
@export var bomb_start_location: Marker3D
@export var tentacle_scene: PackedScene
@export var tentacle_container: Node3D
@export_range(0, 10000) var tentacle_amount: int = 15
@export_range(0.0, 100.0) var tentacle_attack_min_radius: float = 3
@export_range(0.0, 100.0) var tentacle_attack_max_radius: float = 15
@export var tentacle_root: PackedScene
@export_range(0.0, 100.0) var tentacle_damage: int = 15
@export_range(0, 100) var tentacle_root_amount: int = 4
@export_range(0.0, 100.0) var tentacle_slam_damage: int = 30

var num_tentacles_erupted: int = 0

func _ready() -> void:
	anim_tree.tree_root = anim_tree.tree_root.duplicate(true)
	anim_tree.active = true
	$StateMachine/Idle.reset_health.connect(reset_health)
	$HealthBar.set_max_vals(MAX_HEALTH)
	$StateMachine/Dead.died.connect(_remove_me)
	create_bombs()
	create_tentacles()
	create_tentacle_roots()
	health = MAX_HEALTH
	if not origin_position:
		origin_position = global_position

func _physics_process(_delta: float) -> void:
	velocity += get_gravity()
	move_and_slide()

func take_damage(damage_dealt, _body = null):
	if health > MIN_HEALTH:
		anim_tree.set("parameters/Hitflash/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	update_HEALTH( - damage_dealt)
	if $StateMachine.current_state.name.to_lower() == "idle":
		$StateMachine.on_child_transitioned($StateMachine/Idle, "Engage")

func reset_health():
	update_HEALTH(MAX_HEALTH - health)

func update_HEALTH(amount: float):
	health += amount
	$HealthBar.update_health(health)

func _remove_me():
	EventBus.spawn_loot.emit(self)
	EventBus.remove_me.emit(self)

func force_engage():
	$StateMachine/Idle.called = true

func set_called(val: bool):
	$StateMachine/Idle.called = val

func create_bombs():
	for i in range(poison_blast_bullet_amount):
		var poison_bomb_instance = POISON_BOMB_SCENE.instantiate()
		poison_bomb_instance.set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)
		poison_bomb_instance.exploded.connect(reset_bomb)
		bombs.add_child(poison_bomb_instance, true)
		poison_bomb_instance.global_position = RESET_POSITION

func ready_bombs(player_location):
	for bomb in bombs.get_children():
		bomb.set_deferred("process_mode", Node.PROCESS_MODE_INHERIT)
		bomb.fire(bomb_start_location.global_position, player_location, global_transform)

func reset_bomb(bomb):
	bomb.global_position = RESET_POSITION
	bomb.set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)

func create_tentacles():
	for i in range(tentacle_amount):
		var tentacle_instance: Area3D = tentacle_scene.instantiate()
		tentacle_container.add_child(tentacle_instance)
		tentacle_instance.hide()
		tentacle_instance.damage = tentacle_damage
		tentacle_instance.set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)

func create_tentacle_roots():
	var radiant_size: float = 360.0 / tentacle_root_amount
	for i in range(tentacle_root_amount):
		var tentacle_root_instance = tentacle_root.instantiate()
		tentacle_root_container.add_child(tentacle_root_instance, true)
		tentacle_root_instance.rotate_y(deg_to_rad(radiant_size * i))

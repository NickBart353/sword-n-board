extends Enemy

@onready var bombs: Node3D = $Bombs

@export var POISON_BOMB_SCENE: PackedScene
@export var poison_blast_bullet_amount: int = 10

func _ready() -> void:
	anim_tree.tree_root = anim_tree.tree_root.duplicate(true)
	anim_tree.active = true
	$StateMachine/Idle.reset_health.connect(reset_health)
	$HealthBar.set_max_vals(MAX_HEALTH)
	$StateMachine/Dead.died.connect(_remove_me)
	health = MAX_HEALTH
	if not origin_position:
		origin_position = global_position
	create_bombs()

func _physics_process(_delta: float) -> void:
	move_and_slide()

func take_damage(damage_dealt, _body = null):
	if health > MIN_HEALTH:
		anim_tree.set("parameters/OneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	update_HEALTH( - damage_dealt)
	if $StateMachine.current_state.name.to_lower() == "idle":
		$StateMachine.on_child_transitioned($StateMachine/Idle, "Engage")

func reset_health():
	update_HEALTH(MAX_HEALTH - health)

func update_HEALTH(amount: float):
	health += amount
	$HealthBar.update_health(health)

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
		bomb.set_deferred("process_mode", Node.PROCESS_MODE_ALWAYS)
		bomb.fire($BombPosition.global_position, player_location, global_transform)

func reset_bomb(bomb):
	bomb.global_position = RESET_POSITION
	bomb.set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)

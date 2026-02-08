extends Enemy

@onready var bombs: Node3D = $Bombs
@onready var anim_tree: AnimationTree = $AnimationTree

@export var MIN_HEALTH = 0
@export var MAX_HEALTH = 1000
@export var POISON_BOMB_SCENE: PackedScene
@export var poison_blast_bullet_amount: int = 10

const RESET_POSITION: Vector3 = Vector3(-100000, -100000, -100000)

var origin_position: Vector3
var health

func _ready() -> void:
	anim_tree.tree_root = anim_tree.tree_root.duplicate(true)
	anim_tree.active = true
	$HealthBar.set_max_vals(MAX_HEALTH)
	$StateMachine/Dead.died.connect(_remove_me)
	health = MAX_HEALTH
	if not origin_position:
		origin_position = global_position
	create_bombs()

func _physics_process(_delta: float) -> void:
	move_and_slide()

func take_damage(damage_dealt):
	if health > MIN_HEALTH:
		anim_tree.set("parameters/OneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	health -= damage_dealt
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
		poison_bomb_instance.get_node("ProjectileExplosion").process_mode = Node.PROCESS_MODE_DISABLED
		poison_bomb_instance.get_node("ProjectileExplosion").exploded.connect(reset_bomb)
		bombs.add_child(poison_bomb_instance, true)
		poison_bomb_instance.global_position = RESET_POSITION

func ready_bombs(player_location):
	for bomb in bombs.get_children():
		bomb.process_mode = Node.PROCESS_MODE_INHERIT
		bomb.get_node("ProjectileExplosion").fire($BombPosition.global_position, player_location)

func reset_bomb(bomb):
	bomb.global_position = RESET_POSITION
	bomb.get_node("ProjectileExplosion").set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)

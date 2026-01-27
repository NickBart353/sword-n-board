extends Enemy

@onready var bombs: Node3D = $Bombs

@export var MIN_HEALTH = 0
@export var MAX_HEALTH = 1000
@export var POISON_BOMB_SCENE: PackedScene
@export var poison_blast_bullet_amount: int = 10

const RESET_POSITION: Vector3 = Vector3(-100000, -100000, -100000)

var origin_position: Vector3
var health

func _ready() -> void:
	health = MAX_HEALTH
	if not origin_position:
		origin_position = global_position
	create_bombs()

func _physics_process(_delta: float) -> void:
	move_and_slide()

func take_damage(_damage_dealt, _body):
	pass

func create_bombs():
	for i in range(poison_blast_bullet_amount):
		var poison_bomb_instance = POISON_BOMB_SCENE.instantiate()
		poison_bomb_instance.process_mode = Node.PROCESS_MODE_DISABLED
		poison_bomb_instance.exploded.connect(reset_bomb)
		bombs.add_child(poison_bomb_instance, true)
		poison_bomb_instance.global_position = RESET_POSITION

func ready_bombs(player_location):
	for bomb in bombs.get_children():
		bomb.process_mode = Node.PROCESS_MODE_INHERIT
		bomb.fire($BombPosition.global_position, global_position, player_location)

func reset_bomb(bomb):
	bomb.global_position = RESET_POSITION
	bomb.set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)

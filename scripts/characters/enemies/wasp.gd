extends Enemy

@onready var bombs: Node3D = $Bombs

@export var POISON_BOMB_SCENE: PackedScene
@export var poison_blast_bullet_amount: int = 10

func _ready() -> void:
	super()
	create_bombs()

func _physics_process(_delta: float) -> void:
	move_and_slide()

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
		bomb.fire($BombPosition.global_position, player_location, global_transform)

func reset_bomb(bomb):
	bomb.global_position = RESET_POSITION
	bomb.set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)

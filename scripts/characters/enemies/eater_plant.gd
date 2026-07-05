class_name EaterPlant extends Enemy

@onready var bombs: Node3D = $Bombs
@onready var tentacle_root_container: Node3D = $TentacleRoots
@onready var bomb_delay: Timer = $Timers/BombDelay

@export_group("Bombs - NEW")
@export var POISON_BOMB_MESH: PackedScene
@export var poison_blast_bullet_amount_new: int = 10
@export var bomb_start_location_new: Marker3D
@onready var bomb_multi_mesh: MultiMeshInstance3D = $BombMultiMesh

@export_group("Bombs")
@export var POISON_BOMB_SCENE: PackedScene
@export var poison_blast_bullet_amount: int = 10
@export var bomb_start_location: Marker3D

@export_group("Tentacle Spikes - NEW")
@export var tentacle_spike_mesh: MultiMeshInstance3D
@export_range(0.0, 1000.0) var tentacle_spike_range: float = 100
@export var spike_damage: int = 15

@export_group("Tentacle Spikes")
@export var tentacle_scene: PackedScene
@export var tentacle_container: Node3D
@export_range(0, 10000) var tentacle_amount: int = 15
@export_range(0.0, 100.0) var tentacle_attack_min_radius: float = 3
@export_range(0.0, 100.0) var tentacle_attack_max_radius: float = 15

@export_group("Tentacle Slam")
@export var tentacle_root: PackedScene
@export_range(0.0, 100.0) var tentacle_damage: int = 15
@export_range(0, 100) var tentacle_root_amount: int = 4
@export_range(0.0, 100.0) var tentacle_slam_damage: int = 30

var num_tentacles_erupted: int = 0

func _ready() -> void:
	super()
	create_bombs()
	create_tentacles()
	create_tentacle_roots()
	bomb_multi_mesh.multimesh.instance_count = poison_blast_bullet_amount_new
	tentacle_spike_mesh.set_data(tentacle_amount, spike_damage)

func _physics_process(_delta: float) -> void:
	velocity += get_gravity()
	move_and_slide()

func create_bombs():
	for instance_id in bomb_multi_mesh.multimesh.instance_count:
		bomb_multi_mesh.multimesh.set_instance_transform(instance_id, Transform3D(Basis(), RESET_POSITION))
	#for i in range(poison_blast_bullet_amount):
		#var poison_bomb_instance = POISON_BOMB_SCENE.instantiate()
		#poison_bomb_instance.set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)
		#poison_bomb_instance.exploded.connect(reset_bomb)
		#bombs.add_child(poison_bomb_instance, true)
		#poison_bomb_instance.global_position = RESET_POSITION

var shot = false

func ready_bombs(player_location: Vector3):
	#var bullet_delay: float = 0.01
	#var time_accumulator: float = 0.0
	for bomb in bombs.get_children():
		#time_accumulator = 0.0
		#var delta = get_process_delta_time() 
		#while time_accumulator < bullet_delay:
			#time_accumulator += delta
		bomb.set_deferred("process_mode", Node.PROCESS_MODE_INHERIT)
		bomb.fire(bomb_start_location.global_position, player_location, global_transform)
		
		#bomb_delay.start()
		#await bomb_delay.timeout

	$StateMachine/PoisonBurst.burst_finished()

func reset_bomb(bomb):
	bomb.global_position = RESET_POSITION
	bomb.set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)

func create_tentacles():
	for i in range(tentacle_amount):
		var tentacle_instance: Area3D = tentacle_scene.instantiate()
		tentacle_container.add_child(tentacle_instance)
		tentacle_instance.hide()
		tentacle_instance.damage = tentacle_damage
		tentacle_instance.wait_duration = $Timers/EruptionCooldown.wait_time - 3
		tentacle_instance.set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)

func create_tentacle_roots():
	var radiant_size: float = 360.0 / tentacle_root_amount
	for i in range(tentacle_root_amount):
		var tentacle_root_instance = tentacle_root.instantiate()
		tentacle_root_container.add_child(tentacle_root_instance, true)
		tentacle_root_instance.rotate_y(deg_to_rad(radiant_size * i))


func _on_bomb_delay_timeout() -> void:
	pass


func _on_timer_timeout() -> void:
	pass # Replace with function body.

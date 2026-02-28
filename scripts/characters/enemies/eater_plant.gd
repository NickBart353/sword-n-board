extends Enemy

@onready var bombs: Node3D = $Bombs

@export var POISON_BOMB_SCENE: PackedScene
@export var poison_blast_bullet_amount: int = 10
@export var bomb_start_location: Marker3D
@export var tentacle_scene: PackedScene
@export var tentacle_container: Node3D
@export_range(0, 100) var tentacle_amount: int = 15
@export_range(0.0, 100.0) var tentacle_attack_min_radius: float = 3
@export_range(0.0, 100.0) var tentacle_attack_max_radius: float = 15
@export_range(0.0, 100.0) var tentacle_damage: int = 15

var num_tentacles_erupted: int = 0

func _ready() -> void:
	anim_tree.tree_root = anim_tree.tree_root.duplicate(true)
	anim_tree.active = true
	$StateMachine/Idle.reset_health.connect(reset_health)
	$HealthBar.set_max_vals(MAX_HEALTH)
	$StateMachine/Dead.died.connect(_remove_me)
	create_bombs()
	create_tentacles()
	health = MAX_HEALTH
	if not origin_position:
		origin_position = global_position

func _physics_process(_delta: float) -> void:
	velocity += get_gravity()
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
		#if not tentacle_instance.finished_eruption.is_connected(_reset_tentacles):
			#tentacle_instance.finished_eruption.connect(_reset_tentacles)
		#if not tentacle_instance.ground_point_above.is_connected(_create_rumbling_vfx_at_tentacle_spawn):
			#tentacle_instance.ground_point_above.connect(_create_rumbling_vfx_at_tentacle_spawn)
		tentacle_instance.set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)

#func _create_rumbling_vfx_at_tentacle_spawn(tentacle_spawn: Vector3):
	#VfxManager.create_vfx_from_enum(VfxManager.VFX.RUMBLING, tentacle_spawn)

#func ready_tentacles():
	#for tentacle in tentacle_container.get_children():
		#tentacle.set_deferred("process_mode", Node.PROCESS_MODE_INHERIT)
		#tentacle.global_position = global_position + Vector3(randf_range(-tentacle_attack_max_radius, tentacle_attack_max_radius) + tentacle_attack_min_radius, -12, randf_range(-tentacle_attack_max_radius, tentacle_attack_max_radius) + tentacle_attack_min_radius)

#func erupt_tentacles():
	#for tentacle in tentacle_container.get_children():
		#tentacle.erupt()

#func _reset_tentacles(_tentacle: Area3D):
	#pass
	#num_tentacles_erupted += 1
	#if num_tentacles_erupted == tentacle_container.get_children().size():
		#num_tentacles_erupted = 0
		#$StateMachine/TentacleEruption.finished_erupting()

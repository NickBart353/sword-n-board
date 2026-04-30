extends Ability

@onready var anim_player = $"../../AnimationPlayer"
@onready var attack_timer = $"../../Timers/AttackTimer"

@export var magic_projectile: PackedScene
@export_group("ManaCost")
@export_range(0.0, 100.0) var casting_cost = 25.0

signal spawn_magic_projectile

const allowed_weapons: Array = [ItemData.ITEM_TYPE.BOOK
	]

var weapon: Node
var offhand: Node
var cast: int = 0
var casting: bool = false
var cast_in_progress: bool = false
var combo_count: int

var process: bool = true

func set_item(item: Node) -> void:
	reset()
	if item is Weapon:
		if item.data.item_type in allowed_weapons:
			weapon = item
			combo_count = item.data.combo_size
			process = true
			return
	process = false

func apply_ability(input: Node, state_controller: Node, movement: Node, abilities: Node, delta: float) -> void:
	if not process: return
	if not movement.dashing and not state_controller.is_player_busy():
		if input.attack and not cast_in_progress and player.use_mana(casting_cost):
			casting = true
			cast_in_progress = true
			if cast == 0 or cast == 2:
				cast = 1
			else:
				cast += 1

func _book_animation_started(anim_name: StringName) -> void:
	if anim_name == "Book{0}".format([cast]):
		casting = false

func _book_animation_ended(anim_name: StringName) -> void:
	if anim_name == "Book{0}".format([cast]):
		cast_in_progress = false
		_shoot_projectile()
		attack_timer.start()

func _shoot_projectile():
	var shooting_direction: Vector3 = player.get_looking_direction()
	var projectile_transform: Transform3D = player.get_camera_transform()
	var proj_instance = magic_projectile.instantiate()
	var projectile_spawn_position = player.get_node_or_null("Head/FieldOfView/LeftHand/MagicBall")
	if not projectile_spawn_position:
		projectile_spawn_position = $"../../Head/FieldOfView/LeftHand".global_position
	else:
		projectile_spawn_position = projectile_spawn_position.global_position
	spawn_magic_projectile.emit(proj_instance, projectile_spawn_position, shooting_direction, projectile_transform, true)

func _remove_proj(proj: Node):
	proj.queue_free()

func reset():
	#weapon = null
	cast = 0 
	casting = false
	cast_in_progress = false

func _on_attack_timer_timeout() -> void:
	if not cast_in_progress:
		cast = 0

func channel_book(channel_time: float):
	if offhand:
		offhand.play_charge_animation(channel_time)

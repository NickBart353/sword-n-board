extends Ability

@onready var anim_player = $"../../AnimationPlayer"
@onready var attack_timer = $"../../Timers/AttackTimer"
@export var magic_projectile: PackedScene

signal spawn_magic_projectile

var weapon: Node
var offhand: Node
var cast: int = 0
var casting: bool = false
var cast_in_progress: bool = false

func apply_ability(input: Node, state_controller: Node, movement: Node, abilities: Node, delta: float) -> void:
	if not weapon == player.get_equipped_primary() or not weapon:
		weapon = player.get_equipped_primary()
	if not offhand and not offhand == weapon:
		offhand = player.get_equipped_secondary()
	if not weapon is MagicWeapon: 
		reset()
		return
	
	if not movement.dashing and not state_controller.is_player_busy():
		if input.attack and not cast_in_progress:
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
	weapon = null
	cast = 0 
	casting = false
	cast_in_progress = false

func _on_attack_timer_timeout() -> void:
	if not cast_in_progress:
		cast = 0

func channel_book(channel_time: float):
	if offhand:
		offhand.play_charge_animation(channel_time)

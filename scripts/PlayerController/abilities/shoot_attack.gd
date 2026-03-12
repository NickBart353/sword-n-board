extends Ability

@onready var anim_player = $"../../AnimationPlayer"
@export var arrow_projectile: PackedScene

signal spawn_projectile

var weapon: Node
var shoot: int = 0
var shooting: bool = false
var shoot_in_progress: bool = false
var charging: bool = false
var max_charge: bool = false
var released: bool = true

func apply_ability(input: Node, state_controller: Node, movement: Node, abilities: Node, delta: float) -> void:
	if not weapon == player.get_equipped_primary():
		weapon = player.get_equipped_primary()
	if not weapon is RangedWeapon: 
		reset()
		return
	
	if not movement.dashing and state_controller.current_state != StateController.STATE.CONSUMING:
		if input.attack and not shoot_in_progress and not charging and released:
			shoot = 1
			charging = true
			shooting = true
			shoot_in_progress = true
			released = false
		if charging and not input.attack and shoot == 1 and not released:
			#BUG: when channeling bow and releasing as charge_maxed() happens - no animation plays
			released = true
			reset()
		if max_charge and not input.attack and not released:
			released = true
			shoot = 3
			max_charge = false
			shoot_projectile()

func charge_maxed():
	if not released:
		shoot = 2
		max_charge = true

func shoot_projectile():
	var shooting_direction: Vector3 = player.get_looking_direction()
	var projectile_transform: Transform3D = player.get_camera_transform()
	var proj_instance = arrow_projectile.instantiate()
	var projectile_spawn_position = player.get_node_or_null("Head/FieldOfView/RightHand/Bow")
	if not projectile_spawn_position:
		projectile_spawn_position = $"../../Head/FieldOfView/RightHand".global_position
	else:
		projectile_spawn_position = projectile_spawn_position.global_position
	spawn_projectile.emit(proj_instance, projectile_spawn_position, shooting_direction, projectile_transform, true)
	
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Bow3":
		reset()

func reset():
	shoot = 0
	max_charge = false
	weapon = null
	shooting = false
	shoot_in_progress = false
	charging = false

extends Ability

@onready var anim_player = $"../../AnimationPlayer"

@export var arrow_projectile: PackedScene
@export var arrow_damage: int = 15
@export_group("StaminaCost")
@export_range(0.0, 100.0) var bow_cost = 15.0

signal spawn_projectile

const allowed_weapons: Array = [ItemData.ITEM_TYPE.BOW]

var weapon: Node
var shoot: int = 0
var shooting: bool = false
var shoot_in_progress: bool = false
var charging: bool = false
var max_charge: bool = false
var released: bool = true
var enough_stamina: bool = false
var combo_count: int
var process: bool = false

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
	if charging:
		enough_stamina = player.use_stamina(bow_cost * delta)
	if max_charge and not released and not enough_stamina:
		released = true
		shoot = 3
		max_charge = false
		shoot_projectile()
	if charging and not enough_stamina:
		reset()
		return
		
	if not movement.dashing and not state_controller.is_player_busy():
		if (input.hold_primary and not shoot_in_progress and not charging and released):
			shoot = 1
			charging = true
			shooting = true
			shoot_in_progress = true
			released = false
		if (charging and not input.hold_primary and shoot == 1 and not released):
			released = true
			reset()
		if max_charge and not input.hold_primary and not released:
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
	proj_instance.damage = arrow_damage
	#var projectile_spawn_position = player.get_node_or_null("Head/FieldOfView/RightHand/Bow")
	var projectile_spawn_position = player.get_node_or_null("Head/RightHand/Bow")
	if not projectile_spawn_position:
		#projectile_spawn_position = $"../../Head/FieldOfView/RightHand".global_position
		projectile_spawn_position = $"../../Head/RightHand".global_position
	else:
		projectile_spawn_position = projectile_spawn_position.global_position
	spawn_projectile.emit(proj_instance, projectile_spawn_position, shooting_direction, projectile_transform, true)
	
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Bow3":
		reset()

func reset():
	shoot = 0
	max_charge = false
	#weapon = null
	shooting = false
	shoot_in_progress = false
	charging = false
	released = true

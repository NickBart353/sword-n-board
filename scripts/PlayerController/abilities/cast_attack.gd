extends Ability

@onready var anim_player = $"../../AnimationPlayer"
@onready var attack_timer = $"../../Timers/AttackTimer"
@export var magic_projectile: PackedScene

signal spawn_magic_projectile

var weapon: Node
var cast: int = 0
var casting: bool = false
var cast_in_progress: bool = false

func apply_ability(input: Node, movement: Node, abilities: Node, delta: float) -> void:
	weapon = player.get_equipped_primary()
	if not weapon is MagicWeapon: 
		reset()
		return
	
	if not movement.dashing:
		if input.primary and not cast_in_progress:
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
	var proj_instance = magic_projectile.instantiate()
	spawn_magic_projectile.emit(proj_instance, $"../../Head/FieldOfView/LeftHand".global_position, shooting_direction)
	#$"../../Head/FieldOfView/LeftHand".add_child(proj_instance)
	#proj_instance.fire($"../../Head/FieldOfView/LeftHand".global_position, shooting_direction)
	#proj_instance.exploded.connect(_remove_proj)

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

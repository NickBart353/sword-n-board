extends Ability

@onready var anim_player = $"../../AnimationPlayer"
@onready var attack_timer = $"../../Timers/AttackTimer"

var weapon: Node
var cast: int = 0
var casting: bool = false
var cast_in_progress: bool = false

func apply_ability(input: Node, movement: Node, abilities: Node, delta: float) -> void:
	weapon = player.get_equipped_primary()
	if not weapon is MagicWeapon: return
	
	if not movement.dashing:
		if input.primary and not cast_in_progress:
			print("test")
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
	print(anim_name)
	if anim_name == "Book{0}".format([cast]):
		cast_in_progress = false
		_shoot_projectile()
		attack_timer.start()

func _shoot_projectile():
	pass

func reset():
	weapon = null
	cast = 0 
	casting = false
	cast_in_progress = false

func _on_attack_timer_timeout() -> void:
	if not cast_in_progress:
		cast = 0

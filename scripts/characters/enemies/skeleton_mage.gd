extends Enemy

const MAX_HEALTH = 100
const MIN_HEALTH = 0

var health = MAX_HEALTH

var isKnockedBack = false
var has_gone_ariborne = false
var dying = false
var attacking = false
var hunting = false

var hunting_bodies: Array
var attacking_bodies: Array
var damage = 10

var level = 5

signal died

@export var movement_speed = 5

@onready var iFrameTimer = $IFrame
@onready var anim_player = $skeleton_mage/AnimationPlayer

func _physics_process(delta: float) -> void:
	if dying: return
	if not anim_player.is_playing():
		anim_player.play("Idle")
	
	if isKnockedBack and not is_on_floor():
		has_gone_ariborne = true
	
	if is_on_floor() and isKnockedBack and has_gone_ariborne:
		isKnockedBack = false
		has_gone_ariborne = false
		velocity.x = 0
		velocity.z = 0
	
	if not attacking:
		hunting_bodies = $HuntRange.get_overlapping_bodies()
		for body in hunting_bodies:
			if body is Player:
				if anim_player.current_animation != "Walking_A":
					anim_player.play("Walking_A")
				hunting = true
				var direction: Vector3 = global_position.direction_to(body.global_position)
				velocity.x = direction.x * movement_speed
				velocity.z = direction.z * movement_speed
				look_at(body.global_position)
	
	attacking_bodies = $AttackRange.get_overlapping_bodies()
	for body in attacking_bodies:
		if body is Player:
			if anim_player.current_animation != "1H_Melee_Attack_Jump_Chop":
				hunting = false
				attacking = true
				anim_player.play("1H_Melee_Attack_Jump_Chop")
			if not isKnockedBack:
				var direction: Vector3 = global_position.direction_to(body.global_position)
				velocity.x = direction.x * movement_speed
				velocity.z = direction.z * movement_speed
				
			look_at(body.global_position)
			
	if not hunting and not attacking and is_on_floor():
		velocity = Vector3.ZERO
	
	velocity.normalized()
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	move_and_slide()
	hunting = false

func take_damage(damage_dealt, body):
	if not dying:
		if iFrameTimer.is_stopped():
			iFrameTimer.start()
			health -= damage_dealt
			$HitFlashPlayer.play("hitflash")
			_apply_knockback(body)
		if health <= MIN_HEALTH:
			_die()

func _apply_knockback(body):
	var knockbackDirection = body.global_position.direction_to(global_position)
	velocity.y = body.knockbackStrength_vertical
	velocity.x = knockbackDirection.x * body.knockbackStrength_horizontal
	velocity.z = knockbackDirection.y * body.knockbackStrength_horizontal
	isKnockedBack = true

func _on_i_frame_timeout() -> void:
	pass

func _die():
	dying = true
	anim_player.stop()
	anim_player.play("Death_A")
	died.emit(self)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Death_A":
		queue_free()
	if anim_name == "1H_Melee_Attack_Jump_Chop":
		attacking = false
		var attacked_bodies: Array = $Attack.get_overlapping_bodies()
		for body in attacked_bodies:
			if body is Player:
				body.take_damage(damage, self)

#func _on_hunt_range_body_entered(body: Node3D) -> void:
	#if body is Player:f
		#if anim_player.current_animation != "Walking_A":
			#anim_player.play("Walking_A")
		#
		#velocity = global_position.direction_to(body.global_position) * movement_speed

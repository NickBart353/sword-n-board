extends Enemy

const MAX_HEALTH = 100
const MIN_HEALTH = 0

var health = MAX_HEALTH
var isKnockedBack = false
var has_gone_ariborne = false

@onready var iFrameTimer = $IFrame
@onready var anim_player = $skeleton_mage/AnimationPlayer

func _physics_process(delta: float) -> void:
	if not anim_player.is_playing():
		anim_player.play("Idle")
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if isKnockedBack and not is_on_floor():
		has_gone_ariborne = true
	
	if is_on_floor() and isKnockedBack and has_gone_ariborne:
		isKnockedBack = false
		has_gone_ariborne = false
		velocity.x = 0
		velocity.z = 0
	
	move_and_slide()

func take_damage(damage, body):
	if iFrameTimer.is_stopped():
		iFrameTimer.start()
		health -= damage
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
	anim_player.stop()
	anim_player.play("Death_A")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Death_A":
		queue_free()

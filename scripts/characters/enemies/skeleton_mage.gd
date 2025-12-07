extends Enemy

const MAX_HEALTH = 100
const MIN_HEALTH = 0

var health = MAX_HEALTH
@onready var iFrameTimer = $IFrame
@onready var anim_player = $skeleton_mage/AnimationPlayer

func _process(_delta: float) -> void:
	if anim_player.current_animation != "Idle":
		anim_player.play("Idle")

func take_damage(damage):
	if iFrameTimer.is_stopped():
		iFrameTimer.start()
		health -= damage
	if health <= MIN_HEALTH:
		queue_free()

func _on_i_frame_timeout() -> void:
	pass 

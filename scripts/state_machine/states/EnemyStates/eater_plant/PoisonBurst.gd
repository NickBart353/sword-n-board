extends EnemyState

@export var bullet_position: Node
@export var cooldown_timer: Timer
@export var fire_rate: float = 0.01
@export var poison_burst_damage: int = 9

var fired: bool = false
var target_location: Vector3
var fire_queue: Array = []
var time_accumulator: float =  0.0

func Enter():
	super()
	time_accumulator = 0.0
	AudioManager.play_audio_from_resource(audio_resource, enemy.global_position, AudioManager.BUS.SFX, offset_audio, audio_volume, audio_max_range)
	fired = false
	fire_queue = enemy.bombs.get_children()
	target_location = Vector3(enemy.global_position.x, enemy.global_position.y + 20, enemy.global_position.z)
	#enemy.ready_bombs(target_location)
	#cooldown_timer.start()
	#fired = true

func Exit():
	super()

func Physics_Update(delta: float) -> void:
	super(delta)
	if not fired:
		time_accumulator += delta
		if time_accumulator > fire_rate:
			fire_queue[0].set_deferred("process_mode", Node.PROCESS_MODE_INHERIT)
			fire_queue[0].fire(enemy.bomb_start_location.global_position, target_location, enemy.global_transform)
			fire_queue[0].damage = poison_burst_damage
			fire_queue.remove_at(0)
			if not fire_queue:
				fired = true
				cooldown_timer.start()
				burst_finished()

func burst_finished():
	Transitioned.emit(self, "Follow")

extends EnemyState

@export var eruption_cooldown: Timer
@export var eruption_damage: float = 25

var is_erupted: bool
var time_accumulator: float =  0.0
var eruption_rate: float = 0.01
var eruption_queue: Array = []

func Enter():
	super()
	time_accumulator = 0.0
	AudioManager.play_audio_from_resource(audio_resource, enemy.global_position, AudioManager.BUS.SFX, offset_audio, audio_volume, audio_max_range)
	#for tentacle in enemy.tentacle_container.get_children():
		#tentacle.erupt()
	eruption_queue = enemy.tentacle_container.get_children()
	var swapped: bool = false
	for i in range(enemy.tentacle_amount):
		swapped = false
		for j in range(enemy.tentacle_amount - i - 1):
			if enemy.tentacle_container.get_child(i).global_position.distance_to(enemy.global_position) < enemy.tentacle_container.get_child(j + 1).global_position.distance_to(enemy.global_position):
				var temp: Vector3 = enemy.tentacle_container.get_child(i).global_position
				enemy.tentacle_container.get_child(i).global_position = enemy.tentacle_container.get_child(j + 1).global_position
				enemy.tentacle_container.get_child(j + 1).global_position = temp
				swapped = true
		if not swapped:
			break
			
	eruption_cooldown.start()
	is_erupted = false

func Exit():
	super()

func Physics_Update(delta: float) -> void:
	super(delta)
	if not is_erupted:
		time_accumulator += delta
		if time_accumulator > eruption_rate:
			#eruption_queue[0].set_deferred("process_mode", Node.PROCESS_MODE_INHERIT)
			for i in range(20):
				eruption_queue[0].erupt()#(enemy.bomb_start_location.global_position, target_location, enemy.global_transform)
				eruption_queue[0].damage = eruption_damage
				eruption_queue.remove_at(0)
				time_accumulator = 0.0
				if not eruption_queue:
					is_erupted = true
					eruption_cooldown.start()
					finished_erupting()
					break
	#if is_erupted:
		#finished_erupting()

func finished_erupting():
	Transitioned.emit(self, "Follow")

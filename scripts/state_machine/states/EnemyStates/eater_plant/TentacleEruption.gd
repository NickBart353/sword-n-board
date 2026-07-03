extends EnemyState

@export var eruption_cooldown: Timer
@export var eruption_damage: float = 25

var is_erupted: bool

func Enter():
	super()
	AudioManager.play_audio_from_resource(audio_resource, enemy.global_position, AudioManager.BUS.SFX, offset_audio, audio_volume, audio_max_range)
	enemy.spike_positions
	
	eruption_cooldown.start()
	is_erupted = false

func Exit():
	super()

func Physics_Update(delta: float) -> void:
	super(delta)
	if not is_erupted:
		for i in 20:
			pass

#TODO: create areas, erupt areas + multimeshes, change area -> static, connect them to cleanup

func finished_erupting():
	is_erupted = true
	Transitioned.emit(self, "Follow")

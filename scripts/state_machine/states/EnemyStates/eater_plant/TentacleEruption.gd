extends EnemyState

@export var eruption_cooldown: Timer
var is_erupted: bool

func Enter():
	super()
	AudioManager.play_audio_from_resource(audio_resource, enemy.global_position, AudioManager.BUS.SFX, offset_audio, audio_volume, audio_max_range)
	for tentacle in enemy.tentacle_container.get_children():
		tentacle.erupt()
	eruption_cooldown.start()
	is_erupted = true

func Exit():
	super()

func Physics_Update(delta: float) -> void:
	super(delta)
	if is_erupted:
		finished_erupting()

func finished_erupting():
	Transitioned.emit(self, "Follow")

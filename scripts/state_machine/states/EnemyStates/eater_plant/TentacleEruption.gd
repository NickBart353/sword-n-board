extends EnemyState

@export var eruption_cooldown: Timer
@export var tentacle_multimesh: MultiMeshInstance3D

func Enter():
	super()
	AudioManager.play_audio_from_resource(audio_resource, enemy.global_position, AudioManager.BUS.SFX, offset_audio, audio_volume, audio_max_range)
	tentacle_multimesh.erupt()
	eruption_cooldown.start()
	call_deferred("finished_erupting")

func Exit():
	super()

func Physics_Update(delta: float) -> void:
	super(delta)

func finished_erupting():
	Transitioned.emit(self, "Follow")

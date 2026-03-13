extends EnemyState

@export var slam_Scene: PackedScene
@export var slam_position: Node
@export var damage: int = 25

var slam_instance: Area3D

func Enter():
	super()
	slam_instance = slam_Scene.instantiate()
	add_child(slam_instance)
	slam_instance.global_position = slam_position.global_position
	slam_instance.slam_finished.connect(_slam_finished)
	VfxManager.create_vfx_from_enum(VfxManager.VFX.CHANNELING_GROUND_IMPACT_SHORT, slam_position.global_position)

func slam():
	if slam_instance:
		slam_instance.play_slam(damage)
		AudioManager.play_audio_from_resource(audio_resource, enemy.global_position, AudioManager.BUS.SFX, offset_audio, audio_volume, audio_max_range)

func _slam_finished(_slam: Area3D):
	_slam.queue_free()

func _rat_slam_animation_finished():
	Transitioned.emit(self, "Recover")

extends EnemyState

@export var slam_Scene: PackedScene
@export var slam_position: Node
@export var damage: int = 25

var slam_instance: Area3D
var vfx_instance: Basic_VFX

func _ready() -> void:
	vfx_instance = VfxManager.create_vfx_from_enum(VfxManager.VFX.CHANNELING_GROUND_IMPACT_SHORT, Vector3.ZERO, true).instantiate()
	slam_position.add_child.call_deferred(vfx_instance)
	
	slam_instance = slam_Scene.instantiate()
	enemy.add_child.call_deferred(slam_instance)
	if not slam_instance.slam_finished.is_connected(_slam_finished):
		slam_instance.slam_finished.connect(_slam_finished)

func Enter():
	super()
	vfx_instance.play()
	#slam_instance = slam_Scene.instantiate()
	#add_child(slam_instance)
	#VfxManager.create_vfx_from_enum(VfxManager.VFX.CHANNELING_GROUND_IMPACT_SHORT, slam_position.global_position)

func slam():
	if slam_instance:
		slam_instance.play_slam(damage)
		slam_instance.global_position = slam_position.global_position
		AudioManager.play_audio_from_resource(audio_resource, enemy.global_position, AudioManager.BUS.SFX, offset_audio, audio_volume, audio_max_range)

func _slam_finished(_slam: Area3D):
	pass#_slam.queue_free()

func _rat_slam_animation_finished(): #gets called in animation
	Transitioned.emit(self, "Recover")

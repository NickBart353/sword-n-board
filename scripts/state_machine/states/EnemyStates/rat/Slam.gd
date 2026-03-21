extends EnemyAbility

@export var slam_Scene: PackedScene
@export var follow_up_slam_state: Node
@export var slam_position: Node
@export var damage: int = 25

var slam_instance: Area3D
var vfx_instance: Basic_VFX

func _ready() -> void:
	#vfx_instance = VfxManager.create_vfx_from_enum(VfxManager.VFX.CHANNELING_GROUND_IMPACT_LONG, slam_position.global_position, true)
	vfx_instance = VfxManager.create_vfx_from_enum(VfxManager.VFX.CHANNELING_GROUND_IMPACT_LONG, Vector3.ZERO, true).instantiate()
	slam_position.add_child.call_deferred(vfx_instance)
	
	slam_instance = slam_Scene.instantiate()
	enemy.add_child.call_deferred(slam_instance)
	if not slam_instance.slam_finished.is_connected(_slam_finished):
		slam_instance.slam_finished.connect(_slam_finished)

func Enter():
	super()
	vfx_instance.play()

func slam(): #gets called in slam animation
	if slam_instance:
		slam_instance.global_position = slam_position.global_position
		slam_instance.play_slam(damage)
		audio_player.volume_db = audio_volume
		audio_player.max_distance = audio_max_range
		audio_player.stream = audio_resource
		audio_player.play(offset_audio)

func _slam_finished(_slam: Area3D):
	pass#_slam.queue_free()

func start_next_slam():
	cool_down_timer.start()
	Transitioned.emit(self, follow_up_slam_state.name)

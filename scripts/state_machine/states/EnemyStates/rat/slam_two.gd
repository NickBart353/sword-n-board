extends EnemyState

@export var slam_Scene: PackedScene
@export var slam_position: Node
#@export var damage: int = 25
@export var damage: DamageContainer
@export var ground_raycast: RayCast3D

var slam_instance: Attack
var vfx_instance: Basic_VFX

func _ready() -> void:
	vfx_instance = VfxManager.create_vfx_from_enum(VfxManager.VFX.CHANNELING_GROUND_IMPACT_SHORT, Vector3.ZERO, true).instantiate()
	slam_position.add_child.call_deferred(vfx_instance)
	
	slam_instance = slam_Scene.instantiate()
	enemy.add_child.call_deferred(slam_instance)
	if not slam_instance.finished.is_connected(_slam_finished):
		slam_instance.finished.connect(_slam_finished)

func Enter():
	super()
	if ground_raycast:
		_set_correct_position()
	
	vfx_instance.play()

func _set_correct_position() -> void:
	if not ground_raycast.is_colliding():
		return
	var normal: Vector3 = ground_raycast.get_collision_normal()
	var new_basis: Basis = Basis()
	new_basis.y = normal
	new_basis.x = normal.cross(enemy.global_transform.basis.z).normalized()
	new_basis.z = new_basis.x.cross(normal).normalized()
	enemy.global_transform.basis = new_basis.orthonormalized()

func slam():
	if slam_instance:
		slam_instance.attack(slam_position.global_transform, damage)
		#slam_instance.global_position = slam_position.global_position
		AudioManager.play_audio_from_resource(audio_resource, enemy.global_position, AudioManager.BUS.SFX, offset_audio, audio_volume, audio_max_range)

func _slam_finished(_slam: Area3D):
	pass#_slam.queue_free()

func _rat_slam_animation_finished(): #gets called in animation
	Transitioned.emit(self, "Recover")

extends Area3D

@onready var resting_timer: Timer = $Timer
@onready var ground_detector_raycast: RayCast3D = $GroundDetector

@export_range(0.0, 100.0) var eruption_speed: float = 10
@export_range(0.0, 100.0) var max_distance: float = 8.0
@export var rumbling_vfx: VfxManager.VFX = VfxManager.VFX.RUMBLING

@export_group("Audio")
@export var audio_resource: AudioStream
@export_range(-100.0, 100.0) var offset_audio: float = 0.0
@export_range(-100.0, 100.0) var audio_volume: float = 0.0
@export_range(-100.0, 1000.0) var audio_max_range: float = 0.0 

signal finished_eruption
signal ground_point_above

var origin_position: Vector3
var top_position: Vector3
var hit: bool
var velocity: Vector3 = Vector3.ZERO
var is_ready_to_erupt: bool
var is_ready_to_return: bool
var damage: int = 5

func _ready() -> void:
	hide()
	pass

func _physics_process(delta: float) -> void:
	if is_ready_to_erupt:
		global_translate(velocity * delta)
		if global_position.distance_to(origin_position) > max_distance:
			is_ready_to_erupt = false
			velocity = Vector3(0, eruption_speed  * -1, 0)
			#AudioManager.play_audio_from_resource(audio_resource, global_position, AudioManager.BUS.SFX, offset_audio, audio_volume, audio_max_range)
			if not top_position:
				top_position = global_position
			resting_timer.start()
	if is_ready_to_return:
		global_translate(velocity * delta)
		if global_position.distance_to(top_position) > max_distance:
			is_ready_to_return = false
			hide()
			finished_eruption.emit(self)

func _on_body_entered(body: Node3D) -> void:
	if is_ready_to_erupt:
		if (body is Player or body is Enemy) and not hit:
			body.take_damage(damage, self)
			hit = true

#func channel_eruption():
	#var ground_height: Vector3 = ground_detector_raycast.get_collision_point()
	#max_distance = global_position.distance_to(ground_height)
	#print(global_position, " ", ground_height)#, ground_detector_raycast.get_collider().get_class())
	#print(max_distance)
	#VfxManager.create_vfx_from_enum(rumbling_vfx, ground_height)
	#ground_point_above.emit(ground_height)

func erupt():
	show()
	origin_position = global_position
	hit = false
	top_position = Vector3.ZERO
	is_ready_to_erupt = true
	is_ready_to_return = false
	velocity = Vector3(0, eruption_speed, 0)

func _on_timer_timeout() -> void:
	is_ready_to_return = true

extends EnemyState

@export var dash_range: int = 40
@export var dash_speed: int = 50
#@export var dash_damage: int = 50
@export var dash_damage: DamageContainer
@export var charge_timer: Timer
@export var cutting_wind: Node
@export var stab_audio_resource: AudioStream

var dash_direction: Vector3
var dash_start_position: Vector3
var last_frame_position: Vector3 
var charge_interrupted: bool = false
var player_hit: bool = false
var ground_hit: bool = false

func Enter():
	super()
	dash_direction = enemy.global_position.direction_to(player.global_position)
	dash_start_position = enemy.global_position
	last_frame_position = Vector3.ZERO

func Exit():
	super()
	player_hit = false
	charge_interrupted = false
	ground_hit = false
	cutting_wind.set_visible(false)
	last_frame_position = Vector3.ZERO
	#TODO: 
	#last_frame_position tech to stop wasps from getting stuck - BUGGED/TEMPORARY - FIX IN FUTURE

func Physics_Update(delta: float) -> void:
	super(delta)
	enemy.velocity = dash_direction * dash_speed
	
	if charge_interrupted:
		Transitioned.emit(self, "Recovering")
		return
	
	if (enemy.global_position.distance_to(dash_start_position) > dash_range) or last_frame_position == enemy.global_position or player_hit or ground_hit:
		Transitioned.emit(self, "Resetting")
		return
	last_frame_position = enemy.global_position

func _on_damage_box_area_entered(area: Area3D) -> void:
	if state_active:
		if area is BlockingComponent and not player_hit:
			charge_interrupted = true
			return
		#if area.is_in_group("Shield") and not player_hit:
		elif area.is_in_group("PlayerHurtBox") and not player_hit and not charge_interrupted:
			player.take_damage(dash_damage, enemy)
			AudioManager.play_audio_from_resource(stab_audio_resource, enemy.global_position, AudioManager.BUS.SFX, offset_audio, audio_volume, audio_max_range)
			player_hit = true

func _on_damage_box_body_entered(body: Node3D) -> void:
	if state_active:
		charge_interrupted = true
		#if body.is_in_group("Tree"):
			#charge_interrupted = true
			#return
		#if body is Terrain3D:
			#charge_interrupted = true
			#ground_hit = true
			#return

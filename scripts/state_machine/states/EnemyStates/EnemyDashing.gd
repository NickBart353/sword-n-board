extends EnemyState

@export var dash_range: int = 40
@export var dash_speed: int = 50
@export var dash_damage: int = 50

@onready var charge_timer = $"../../Timers/ChargeTimer"

var dash_direction: Vector3
var dash_start_position: Vector3
var last_frame_position: Vector3 
var charge_interrupted = false
var player_hit = false

func Enter():
	super()
	dash_direction = enemy.global_position.direction_to(player.global_position)
	dash_start_position = enemy.global_position
	last_frame_position = Vector3.ZERO

func Exit():
	super()
	player_hit = false
	charge_interrupted = false
	$"../../CuttingWind".set_visible(false)
	last_frame_position = Vector3.ZERO
	#TODO: 
	#last_frame_position tech to stop wasps from getting stuck - BUGGED/TEMPORARY - FIX IN FUTURE

func Physics_Update(delta: float) -> void:
	super(delta)
	enemy.velocity = dash_direction * dash_speed
	
	if charge_interrupted:
		Transitioned.emit(self, "Recovering")
		return
	
	if (enemy.global_position.distance_to(dash_start_position) > dash_range) or last_frame_position == enemy.global_position:
		Transitioned.emit(self, "Resetting")
		return
	last_frame_position = enemy.global_position

func _on_damage_box_area_entered(area: Area3D) -> void:
	if state_active:
		if area.is_in_group("PlayerHurtBox"):
			player.take_damage(dash_damage)
			player_hit = true
			charge_interrupted = true

func _on_damage_box_body_entered(body: Node3D) -> void:
	if state_active:
		if body.is_in_group("Tree"):
			charge_interrupted = true

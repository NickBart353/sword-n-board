extends PlayerState

@export var dash_distance: int = 5
@export var dash_speed: int = 30

var dashing_direction: Vector3
var dashing_origin: Vector3

func Enter() -> void:
	super()
	dashing_origin = player.global_position
	
	if not player.input.direction:
		dashing_direction = $"../../Head/FieldOfView".get_global_transform().basis.z
		dashing_direction.z *= -1
		dashing_direction.x *= -1
		dashing_direction.y = 0
		dashing_direction = dashing_direction.normalized()
	else:
		dashing_direction = Vector3(player.input.direction.x, 0, player.input.direction.y)
		dashing_direction = (player.transform.basis * Vector3(dashing_direction.x, 0, dashing_direction.z)).normalized()

func Exit() -> void:
	super()
	player.velocity = Vector3.ZERO

func Update(delta: float) -> void:
	super(delta)

func Physics_Update(delta: float) -> void:
	super(delta)
	
	player.velocity = dashing_direction * dash_speed
	
	if player.global_position.distance_to(dashing_origin) > dash_distance:
		Transitioned.emit(self, "Default")
		return

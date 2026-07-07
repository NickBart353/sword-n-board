extends MultiMeshInstance3D

const RESET_POSITION: Transform3D = Transform3D(Basis(), Vector3(-10000, -10000, -10000))

@onready var timer: Timer = $Timer

@export var enemy: Enemy
@export_range(0.0, 100.0) var eruption_speed: float = 10
@export_range(0.0, 100.0) var max_distance: float = 8.0

var shape_rid: RID
var world_space_id: RID
var area_rids: Array[RID] = []
var static_rids: Array[RID] = []
var current_local_positions: Array[Transform3D] = []
var current_global_positions: Array[Transform3D] = []
var starting_positions_local: Array[Transform3D] = []
var starting_positions_global: Array[Transform3D] = []

var tentacle_count: int
var damage: int

var up: bool = false
var down: bool = false

func _ready() -> void:
	area_rids = []
	world_space_id = get_world_3d().space
	shape_rid = PhysicsServer3D.cylinder_shape_create()
	PhysicsServer3D.shape_set_data(shape_rid, {"height": 10.35, "radius": 0.89})

func set_data(new_tentacle_count: int, new_damage: int) -> void:
	tentacle_count = new_tentacle_count
	damage = new_damage
	multimesh.instance_count = tentacle_count

func set_start_positions(new_start_positions: Array[Vector3]) -> void:
	area_rids.clear()
	static_rids.clear()
	current_local_positions.clear()
	current_global_positions.clear()
	starting_positions_local.clear()
	starting_positions_global.clear()
	
	for i in tentacle_count:
		_create_area_and_static()
	
	assert(tentacle_count == new_start_positions.size() and tentacle_count  == area_rids.size())
	for i in tentacle_count:
		var new_transform: Transform3D = Transform3D(Basis(), new_start_positions[i])
		var local_transform: Transform3D = global_transform.affine_inverse() * new_transform
		starting_positions_local.append(local_transform)
		starting_positions_global.append(new_transform)
		multimesh.set_instance_transform(i, starting_positions_local[i])
		PhysicsServer3D.area_set_transform(area_rids[i], new_transform)
	
	current_local_positions = starting_positions_local.duplicate()
	current_global_positions = starting_positions_global.duplicate()

func _create_area_and_static() -> void:
	var new_area: RID = PhysicsServer3D.area_create()
	PhysicsServer3D.area_add_shape(new_area, shape_rid)
	PhysicsServer3D.area_set_collision_mask(new_area, 4)
	var callable: Callable = Callable(self, "_player_hit")
	PhysicsServer3D.area_set_monitor_callback(new_area, callable)
	PhysicsServer3D.area_set_space(new_area, world_space_id)
	area_rids.append(new_area)
	var new_static: RID = PhysicsServer3D.body_create()
	PhysicsServer3D.body_set_mode(new_static, PhysicsServer3D.BodyMode.BODY_MODE_STATIC)
	PhysicsServer3D.body_add_shape(new_static, shape_rid)
	PhysicsServer3D.body_set_collision_mask(new_static, 7)
	PhysicsServer3D.body_set_collision_layer(new_static, 7)
	PhysicsServer3D.body_set_space(new_static, world_space_id)
	PhysicsServer3D.body_set_state(new_static, PhysicsServer3D.BodyState.BODY_STATE_TRANSFORM, RESET_POSITION)
	static_rids.append(new_static)

func _player_hit(_status: int, _body_rid: RID, object_id: int, _body_shape_idx: int, _self_shape_idx: int) -> void:
	var nody: Node = instance_from_id(object_id)
	if nody is Player:
		nody.take_damage(damage, enemy, false, false)
	_remove_areas_add_statics()

func _remove_areas_add_statics() -> void:
	pass

func erupt() -> void:
	up = true

func _physics_process(delta: float) -> void:
	if up:
		if current_local_positions[0].origin.distance_squared_to(starting_positions_local[0].origin) > (max_distance * max_distance):
			_eruption_finished()
			return
		for i in tentacle_count:
			current_local_positions[i] = Transform3D(Basis(), (current_local_positions[i].origin + Vector3(0, eruption_speed, 0) * delta))
			current_global_positions[i] = Transform3D(Basis(), (current_global_positions[i].origin + Vector3(0, eruption_speed, 0) * delta))
			multimesh.set_instance_transform(i, current_local_positions[i])
			PhysicsServer3D.area_set_transform(area_rids[i], current_global_positions[i])
	elif down:
		if current_local_positions[0].origin.is_equal_approx(starting_positions_local[0].origin):
			_eruption_returned()
			return
		for i in tentacle_count:
			current_local_positions[i] = Transform3D(Basis(), (current_local_positions[i].origin - Vector3(0, eruption_speed, 0) * delta))
			current_global_positions[i] = Transform3D(Basis(), (current_global_positions[i].origin - Vector3(0, eruption_speed, 0) * delta))
			multimesh.set_instance_transform(i, current_local_positions[i])
			#PhysicsServer3D.area_set_transform(area_rids[i], current_global_positions[i])
			PhysicsServer3D.body_set_state(static_rids[i], PhysicsServer3D.BodyState.BODY_STATE_TRANSFORM, current_global_positions[i])

func _eruption_finished() -> void:
	for i in tentacle_count:
		PhysicsServer3D.free_rid(area_rids[i])
		PhysicsServer3D.body_set_state(static_rids[i], PhysicsServer3D.BodyState.BODY_STATE_TRANSFORM, current_global_positions[i])
	area_rids.clear()
	timer.start()
	up = false

func _eruption_returned() -> void:
	for i in tentacle_count:
		PhysicsServer3D.free_rid(static_rids[i])
	static_rids.clear()
	down = false

func _on_timer_timeout() -> void:
	down = true

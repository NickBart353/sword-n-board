extends Node3D

@export_group("Rooms")
@export var basic_room_scene: PackedScene
@export var start_room: PackedScene
@export var end_room: PackedScene
@export var double_room_scene: PackedScene
@export var tunnel_NS_scene: PackedScene
@export var tunnel_EW_scene: PackedScene
@export_group("Dimensions")
@export var dungeon_width: int = 10
@export var dungeon_height: int = 10
@export var room_size: Vector3 = Vector3(20, 20, 20)
@export_group("Player")
@export var player_scene: PackedScene

const NORTH = "North"
const EAST = "East"
const SOUTH = "South"
const WEST = "West"

var room_scenes: Array 
var tunnel_scenes: Array 

var rooms: Array[Array] = []
var pending_openings: Dictionary #[Vector2i, Dictionary[String, bool]]

var room_limit: int
var added_rooms: int

var open_doors: Dictionary #[Vector2i, Array[String]]
var new_rooms: Array[Vector2i] = []

func _ready() -> void:
	for x in range(dungeon_width):
		var collumn: Array[String] = []
		for y in range(dungeon_height):
			collumn.append("Empty")
		rooms.append(collumn)
	
	room_limit = randi_range(1, (dungeon_width * dungeon_height) / 4)
	added_rooms = 0
	_generate_dungeon()

func _generate_dungeon():
	_create_start_room()
	while added_rooms < room_limit:
		_branch_paths()
	_create_end_room()
	_place_rooms_from_list()

func _check_valid_openings():
	pass

func _create_end_room():
	#Dictionary #[Vector2i, Dictionary[String, bool]]
	#which tuples in pending_openings have valid openings for an end room?
	_check_valid_openings()
	var true_openings: Array = []
	for location_tuple in pending_openings:
		var valid_openings: Array = []
		for cardinal_direction in pending_openings[location_tuple]:
			if pending_openings[location_tuple][cardinal_direction] == true:
				valid_openings.append(cardinal_direction)
		if valid_openings.size() > 0:
			true_openings.append({location_tuple: pending_openings[location_tuple]})
	
	var random: int = randi_range(0, true_openings.size() - 1)
	var xy_cord: Vector2i = true_openings[random].keys()[0]
	var openings_dict: Dictionary = true_openings[random][xy_cord]
	var openings: Array = openings_dict.values()
	
	for cardinal_direction in openings:
		if cardinal_direction == true:
			true_openings.append(cardinal_direction)
	random = randi_range(0, true_openings.size() - 1)

	match true_openings[random]:
		NORTH:
			xy_cord.y = xy_cord.y+1
			open_doors.set(NORTH, xy_cord)
		EAST:
			xy_cord.x = xy_cord.x+1
			open_doors.set(EAST, xy_cord)
		SOUTH:
			xy_cord.y = xy_cord.y-1
			open_doors.set(SOUTH, xy_cord)
		WEST:
			xy_cord.x = xy_cord.x-1
			open_doors.set(WEST, xy_cord)
	rooms[xy_cord.x][xy_cord.y] = "End"
	new_rooms.append(Vector2i(xy_cord.x, xy_cord.y))

func _create_start_room():
	var x = randi_range(0, dungeon_width - 1)
	var y = randi_range(0, dungeon_height - 1)
	
	_check_pending_openings(x, y)
	
	rooms[x][y] = "Start"

func _branch_paths():
	for location_tuple in pending_openings:
		var openings: Array = []
		for cardinal_direction in pending_openings[location_tuple]:
			if pending_openings[location_tuple][cardinal_direction] == true:
				openings.append(cardinal_direction)
		
		_pick_random_openings(location_tuple, openings)
	pending_openings.clear()
	for room in new_rooms:
		_check_pending_openings(room.x, room.y)
	new_rooms.clear()

func _pick_random_openings(xy_cord: Vector2i, cardinal_directions: Array):
	var open_directions: Array = _is_space_for_room(xy_cord, cardinal_directions)
	var amount_of_directions = open_directions.size()
	var randomness: Array
	var active_doors: Array = []
	match amount_of_directions:
		0: 
			return
		1: 
			randomness = [1]
		2:
			randomness = [1, 0.5]
		3:
			randomness = [1, 0.66, 0.33]
		4:
			randomness = [1, 0.75, 0.5, 0.25]
	
	for i in range(amount_of_directions):
		var random = randi_range(0, cardinal_directions.size() - 1)
		var random_chance = randf_range(0, 1)
		if random_chance <= randomness[i]:
			match cardinal_directions[random]:
				NORTH:
					xy_cord.y = xy_cord.y+1
					active_doors.append(NORTH)
				EAST:
					xy_cord.x = xy_cord.x+1
					active_doors.append(EAST)
				SOUTH:
					xy_cord.y = xy_cord.y-1
					active_doors.append(SOUTH)
				WEST:
					xy_cord.x = xy_cord.x-1
					active_doors.append(WEST)
			_place_room(xy_cord)
	if active_doors.size() > 0:
		open_doors.set(xy_cord, active_doors)

func _is_space_for_room(xy_cord: Vector2i, cardinal_directions: Array):
	var open_directions = []
	for direction in cardinal_directions:
		match direction:
			NORTH:
				if xy_cord.y + 1 < dungeon_height -1:
					open_directions.append(direction)
			EAST:
				if xy_cord.x + 1 < dungeon_width -1:
					open_directions.append(direction)
			SOUTH:
				if xy_cord.y - 1 > 0:
					open_directions.append(direction)
			WEST:
				if xy_cord.x - 1 > 0:
					open_directions.append(direction)
	return open_directions

func _place_room(xy_cord: Vector2i):
	rooms[xy_cord.x][xy_cord.y] = "Room"
	new_rooms.append(Vector2i(xy_cord.x, xy_cord.y))
	added_rooms += 1

func _check_pending_openings(x: int, y: int):
	var openings: Dictionary = {WEST: false, EAST:false, SOUTH:false, NORTH: false}
	if (x > 0 and rooms[x-1][y] == "Empty"):
		openings[WEST] = true
	if (x < dungeon_width - 1 and rooms[x+1][y] == "Empty"):
		openings[EAST] = true
	if (y > 0 and rooms[x][y-1] == "Empty"):
		openings[SOUTH] = true
	if (y < dungeon_height - 1 and rooms[x][y+1] == "Empty"):
		openings[NORTH] = true
	
	pending_openings.set(Vector2i(x,y), openings)

func _place_rooms_from_list():
	for x in range(dungeon_width):
		for y in range(dungeon_height):
			match rooms[x][y]:
				"Empty":
					pass
				"Start":
					var instance = start_room.instantiate() 
					var loc: Vector2i = Vector2i(x,y)
					#if open_doors[loc] and open_doors[loc] > 0:
						#for cardinal_direction in open_doors[loc]:
							#instance.get_node("Openings/{0}".format([cardinal_direction])).global_position.y -= 20
					var player_instance = player_scene.instantiate()
					instance.transform.origin = Vector3(loc.x * room_size.x, 0, loc.y * room_size.z)
					get_node("Rooms").add_child(instance)
					add_child(player_instance)
					player_instance.global_position = instance.get_node("Spawn").global_position
				"End":
					var instance = end_room.instantiate() 
					
					var loc: Vector2i = Vector2i(x,y)
					#if open_doors[loc] and open_doors[loc] > 0:
						#for cardinal_direction in open_doors[loc]:
							#instance.get_node("Openings/{0}".format([cardinal_direction])).global_position.y -= 20
					instance.transform.origin = Vector3(loc.x * room_size.x, 0, loc.y * room_size.z)
					get_node("Rooms").add_child(instance)
					print("test")
				"Room":
					var instance = basic_room_scene.instantiate() 
					
					var loc: Vector2i = Vector2i(x,y)
					#if open_doors[loc] and open_doors[loc].size() > 0:
						#for cardinal_direction in open_doors[loc]:
							#instance.get_node("Openings/{0}".format([cardinal_direction])).global_position.y -= 20
					instance.transform.origin = Vector3(loc.x * room_size.x, 0, loc.y * room_size.z)
					get_node("Rooms").add_child(instance)
				"_":
					pass

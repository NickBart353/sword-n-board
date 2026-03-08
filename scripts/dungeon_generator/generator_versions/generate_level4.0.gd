extends Main

@export_group("Rooms")
@export var basic_room_scene: PackedScene
@export var start_room: PackedScene
@export var end_room: PackedScene
@export_group("Dimensions")
@export var dungeon_width: int = 10
@export var dungeon_height: int = 10
@export var room_size: Vector3 = Vector3(20, 20, 20)
@export_group("Player")
@export_group("Debug")
@export var room_locations: bool = false

const NORTH = "North"
const EAST = "East"
const SOUTH = "South"
const WEST = "West"

const EMPTY = "Empty"
const START = "Start"
const END = "End"
const ROOM = "Room"

var room_scenes: Array 
var tunnel_scenes: Array 

var rooms: Array[Array] = []
var pending_openings: Dictionary #[Vector2i, Dictionary[String, bool]]
var archived_openings: Dictionary #[Vector2i, Dictionary[String, bool]]

var room_limit: int
var added_rooms: int

var new_rooms: Array[Vector2i] = []

func _ready() -> void:
	for x in range(dungeon_width):
		var collumn: Array[String] = []
		for y in range(dungeon_height):
			collumn.append(EMPTY)
		rooms.append(collumn)
	
	room_limit = randi_range(1, (dungeon_width * dungeon_height) / 4)
	added_rooms = 0
	_generate_dungeon()
	super()

func _generate_dungeon():
	var use_fail_safe: bool = false
	_create_start_room()
	while added_rooms < room_limit:
		var fail_check = added_rooms
		_branch_paths()
		if added_rooms == fail_check:
			use_fail_safe = true
			break
	_create_end_room(use_fail_safe)
	_place_rooms_from_list()

func _create_end_room(use_fail_safe: bool):
	if use_fail_safe or pending_openings.size() == 0: pending_openings = archived_openings
	var true_openings: Array = []
	for location_tuple in pending_openings:
		var valid_openings: Array = []
		for cardinal_direction in pending_openings[location_tuple]:
			if pending_openings[location_tuple][cardinal_direction] == false:
				pending_openings[location_tuple].erase(cardinal_direction)
				continue
			match cardinal_direction:
				NORTH:
					if not ((location_tuple.y + 1) < dungeon_height -1 and rooms[location_tuple.x][location_tuple.y+1] == EMPTY):
						pending_openings[location_tuple].erase(cardinal_direction)
						continue
				EAST:
					if not ((location_tuple.x + 1) < dungeon_width -1 and rooms[location_tuple.x+1][location_tuple.y] == EMPTY):
						pending_openings[location_tuple].erase(cardinal_direction)
						continue
				SOUTH:
					if not ((location_tuple.y - 1) > 0 and rooms[location_tuple.x][location_tuple.y-1] == EMPTY):
						pending_openings[location_tuple].erase(cardinal_direction)
						continue
				WEST:
					if not ((location_tuple.x - 1) > 0 and rooms[location_tuple.x-1][location_tuple.y] == EMPTY):
						pending_openings[location_tuple].erase(cardinal_direction)
						continue
			valid_openings.append(cardinal_direction)
		if valid_openings.size() > 0:
			true_openings.append({location_tuple: pending_openings[location_tuple]})

	if true_openings.size() == 0:
		var stop: bool = false
		for x in range(dungeon_width):
			for y in range(dungeon_height):
				if rooms[x][y] == ROOM:
					rooms[x][y] = END
					stop = true
					break
			if stop:
				break
	else:
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
			EAST:
				xy_cord.x = xy_cord.x+1
			SOUTH:
				xy_cord.y = xy_cord.y-1
			WEST:
				xy_cord.x = xy_cord.x-1
		rooms[xy_cord.x][xy_cord.y] = END
		if room_locations: print("end ", xy_cord)
		new_rooms.append(Vector2i(xy_cord.x, xy_cord.y))

func _create_start_room():
	var x = randi_range(0, dungeon_width - 1)
	var y = randi_range(0, dungeon_height - 1)
	
	_check_pending_openings(x, y)
	if room_locations: print("start({0}, {1})".format([x, y]))
	
	rooms[x][y] = START

func _branch_paths():
	for location_tuple in pending_openings:
		var openings: Array = []
		for cardinal_direction in pending_openings[location_tuple]:
			if pending_openings[location_tuple][cardinal_direction] == true:
				openings.append(cardinal_direction)
		
		_pick_random_openings(location_tuple, openings)
	archived_openings.assign(pending_openings)
	pending_openings.clear()
	for room in new_rooms:
		_check_pending_openings(room.x, room.y)
	new_rooms.clear()

func _pick_random_openings(xy_cord: Vector2i, cardinal_directions: Array):
	var open_directions: Array = _is_space_for_room(xy_cord, cardinal_directions)
	var amount_of_directions = open_directions.size()
	var randomness: Array
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
		var new_xy_coordinate: Vector2i
		if random_chance <= randomness[i]:
			match cardinal_directions[random]:
				NORTH:
					new_xy_coordinate = Vector2i(xy_cord.x, xy_cord.y+1)
				EAST:
					new_xy_coordinate = Vector2i(xy_cord.x+1, xy_cord.y)
				SOUTH:
					new_xy_coordinate = Vector2i(xy_cord.x, xy_cord.y-1)
				WEST:
					new_xy_coordinate = Vector2i(xy_cord.x-1, xy_cord.y)
			_place_room(new_xy_coordinate)

func _is_space_for_room(xy_cord: Vector2i, cardinal_directions: Array):
	var open_directions = []
	for direction in cardinal_directions:
		match direction:
			NORTH:
				if (xy_cord.y + 1) < dungeon_height -1:
					open_directions.append(direction)
			EAST:
				if (xy_cord.x + 1) < dungeon_width -1:
					open_directions.append(direction)
			SOUTH:
				if (xy_cord.y - 1) > 0:
					open_directions.append(direction)
			WEST:
				if (xy_cord.x - 1) > 0:
					open_directions.append(direction)
	return open_directions

func _place_room(xy_cord: Vector2i):
	if room_locations: print(xy_cord)
	if rooms[xy_cord.x][xy_cord.y] == EMPTY:
		rooms[xy_cord.x][xy_cord.y] = ROOM
		new_rooms.append(Vector2i(xy_cord.x, xy_cord.y))
		added_rooms += 1

func _check_pending_openings(x: int, y: int):
	var openings: Dictionary = {WEST: false, EAST:false, SOUTH:false, NORTH: false}
	if ((x - 1) > 0 and rooms[x-1][y] == EMPTY):
		openings[WEST] = true
	if ((x + 1) < dungeon_width - 1 and rooms[x+1][y] == EMPTY):
		openings[EAST] = true
	if ((y - 1) > 0 and rooms[x][y-1] == EMPTY):
		openings[SOUTH] = true
	if ((y + 1) < dungeon_height - 1 and rooms[x][y+1] == EMPTY):
		openings[NORTH] = true
	
	pending_openings.set(Vector2i(x,y), openings)

func _place_rooms_from_list():
	for x in range(dungeon_width):
		for y in range(dungeon_height):
			match rooms[x][y]:
				EMPTY:
					pass
				START:
					var instance = start_room.instantiate() 
					var loc: Vector2i = Vector2i(x,y)
					get_node("Rooms").add_child(instance)
					var directions: Array = _is_room_next_to_me(x,y)
					_open_doors(directions, instance)
					var player_instance = player_scene.instantiate()
					add_child(player_instance)
					instance.transform.origin = Vector3(loc.x * room_size.x, 0, loc.y * room_size.z)
					player_instance.global_position = instance.get_node("Spawn").global_position
				END:
					var instance = end_room.instantiate() 
					
					var loc: Vector2i = Vector2i(x,y)
					get_node("Rooms").add_child(instance)
					var directions: Array = _is_room_next_to_me(x,y)
					_open_doors(directions, instance)
					instance.transform.origin = Vector3(loc.x * room_size.x, 0, loc.y * room_size.z)
				ROOM:
					var instance = basic_room_scene.instantiate() 
					
					var loc: Vector2i = Vector2i(x,y)
					get_node("Rooms").add_child(instance)
					var directions: Array = _is_room_next_to_me(x,y)
					_open_doors(directions, instance)
					instance.transform.origin = Vector3(loc.x * room_size.x, 0, loc.y * room_size.z)
				"_":
					pass

func _is_room_next_to_me(x: int, y: int):
	var directions: Array = []
	if x != (dungeon_width-1):
		if rooms[x+1][y] == START or rooms[x+1][y] == ROOM or rooms[x+1][y] == END:
			directions.append(EAST)
	if x > 0 and rooms[x-1][y] == START or rooms[x-1][y] == ROOM or rooms[x-1][y] == END:
		directions.append(WEST)
	if y != (dungeon_height-1):
		if rooms[x][y+1] == START or rooms[x][y+1] == ROOM or rooms[x][y+1] == END:
			directions.append(NORTH)
	if y > 0 and rooms[x][y-1] == START or rooms[x][y-1] == ROOM or rooms[x][y-1] == END:
		directions.append(SOUTH)
	return directions

func _open_doors(directions: Array, instance):
	for cardinal_direction in directions:
		instance.get_node("Openings/{0}".format([cardinal_direction])).global_position.y += 3.5

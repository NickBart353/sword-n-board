extends Node3D

@export_group("Rooms")
@export var basic_room_scene: PackedScene
@export var start_room: PackedScene
@export var double_room_scene: PackedScene
@export var tunnel_NS_scene: PackedScene
@export var tunnel_EW_scene: PackedScene
@export_group("Dimensions")
@export var dungeon_width: int
@export var dungeon_height: int
@export var room_size: Vector3 = Vector3(10, 10, 10)
@export_group("Player")
@export var player_scene: PackedScene

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

func _create_end_room():
	#Dictionary #[Vector2i, Dictionary[String, bool]]
	var random: int = randi_range(0, pending_openings.size() - 1)
	var xy_cord: Vector2i = pending_openings.keys()[random]
	var openings_dict: Dictionary = pending_openings[xy_cord]
	var openings: Array = openings_dict.values()
	var true_openings: Array = []
	
	for cardinal_direction in openings:
		if cardinal_direction == true:
			true_openings.append(cardinal_direction)
	random = randi_range(0, true_openings.size() - 1)

	match true_openings[random]:
		"N":
			xy_cord.y = xy_cord.y+1
			open_doors.set("North", xy_cord)
		"E":
			xy_cord.x = xy_cord.x+1
			open_doors.set("East", xy_cord)
		"S":
			xy_cord.y = xy_cord.y-1
			open_doors.set("South", xy_cord)
		"W":
			xy_cord.x = xy_cord.x-1
			open_doors.set("West", xy_cord)
			rooms[xy_cord.x][xy_cord.y] = "End"
			_place_room(xy_cord)

func _create_start_room():
	var x = randi_range(0, dungeon_width - 1)
	var y = randi_range(0, dungeon_height - 1)
	
	_check_pending_openings(x, y)
	
	rooms[x][y] = "start"

func _branch_paths():
	for location_tuple in pending_openings:
		var openings: Array = []
		for cardinal_direction in pending_openings[location_tuple]:
			if pending_openings[location_tuple][cardinal_direction] == true:
				openings.append(cardinal_direction)
		
		_is_room_next_to_opening(location_tuple, openings)
	pending_openings.clear()
	for room in new_rooms:
		_check_pending_openings(room.x, room.y)
	new_rooms.clear()

func _is_room_next_to_opening(xy_cord: Vector2i, cardinal_directions: Array):
	var amount_of_directions = cardinal_directions.size()
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
				"N":
					xy_cord.y = xy_cord.y+1
					active_doors.append("North")
				"E":
					xy_cord.x = xy_cord.x+1
					active_doors.append("East")
				"S":
					xy_cord.y = xy_cord.y-1
					active_doors.append("South")
				"W":
					xy_cord.x = xy_cord.x-1
					active_doors.append("West")
			_place_room(xy_cord)
	if active_doors.size() > 0:
		open_doors.set(xy_cord, active_doors)

func _place_room(xy_cord: Vector2i):
	rooms[xy_cord.x][xy_cord.y] = "Room"
	new_rooms.append(Vector2i(xy_cord.x, xy_cord.y))
	added_rooms += 1

func _check_pending_openings(x: int, y: int):
	var openings: Dictionary = {"W": false, "E":false, "S":false, "N": false}
	if (x > 0 and rooms[x-1][y] == "Empty"):
		openings["W"] = true
	if (x < dungeon_width - 1 and rooms[x+1][y] == "Empty"):
		openings["E"] = true
	if (y > 0 and rooms[x][y-1] == "Empty"):
		openings["S"] = true
	if (y < dungeon_height - 1 and rooms[x][y+1] == "Empty"):
		openings["N"] = true
	
	pending_openings.set(Vector2i(x,y), openings)

func _place_rooms_from_list():
	for x in range(dungeon_width):
		for y in range(dungeon_height):
			match rooms[x][y]:
				"Empty":
					pass
				"Start":
					var instance = basic_room_scene.instantiate() 
					
					var loc: Vector2i = Vector2i(x,y)
					if open_doors[loc] and open_doors[loc] > 0:
						for cardinal_direction in open_doors[loc]:
							instance.get_node("Openings/{0}".format([cardinal_direction])).global_position.y -= 20
					get_node("Rooms").add_child(instance)
					
					var player_instance = player_scene.instantiate()
					player_instance.global_position = instance.get_node("Spawn").global_position
					add_child(player_instance)
				"End":
					var instance = basic_room_scene.instantiate() 
					
					var loc: Vector2i = Vector2i(x,y)
					if open_doors[loc] and open_doors[loc] > 0:
						for cardinal_direction in open_doors[loc]:
							instance.get_node("Openings/{0}".format([cardinal_direction])).global_position.y -= 20
					get_node("Rooms").add_child(instance)
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

extends Node3D

@export_group("Rooms")
@export var basic_room_scene: PackedScene
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
var pending_openings: Dictionary
var room_limit: int
var added_rooms: int

func _ready() -> void:
	for x in range(dungeon_width):
		for y in range(dungeon_height):
			rooms[y][x].append("Empty")
	
	room_limit = randi_range(1, (dungeon_width * dungeon_height) / 4)
	_generate_dungeon()
	add_child(player_scene.instantiate())

func _generate_dungeon():
	_create_start_room()
	_branch_paths()
	_place_rooms_from_list()

func _create_start_room():
	var x = randi_range(0, dungeon_width - 1)
	var y = randi_range(0, dungeon_height - 1)
	
	_check_pending_openings(x, y)
	
	rooms[x][y] = "start"

func _branch_paths():
	for location_tuple in pending_openings:
		var openings: Array = []
		for cardinal_direction in location_tuple:
			if location_tuple[cardinal_direction] == true:
				openings.append(cardinal_direction)
		
		_is_room_next_to_opening(location_tuple, openings)
		
		#TODO:
		#CHECKEN OB RAUM NEBEN DEM OPENING IST
		#CHECK PENDING OPENINGS CODE KANN MAN DAFÜR UMFUNKTIONIEREN
		#DANACH TUNNEL PLAZIEREN
		#RANDOM EINE HIMMELSRICHTUNG AUS DER LISTE NEHMEN, UND TUNNEL DRANSETZEN
		#ALGORITHMUS ENTWICKELN UM IMMER KLEINERE CHANCE ZU HABEN, EINEN TUNNEL ZU PLATZIEREN

func _is_room_next_to_opening(xy_cord: Vector2i, directions: Array[String]):
	var size:int = directions.size()
	for counter in range(size):
		var random = randi_range(0, directions.size()-1)
		
	#iterate through cardinal directions at random and check if you can add a room
	#if so call _place_room() with cords
	#reduce chance to add room

func _place_room(x: int, y: int):
	pass

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
					get_node("Rooms")
				"_":
					pass

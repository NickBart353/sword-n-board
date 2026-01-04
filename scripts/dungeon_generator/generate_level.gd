extends Node3D

@export_group("Rooms")
@export var basic_room_scene: PackedScene
@export var basic_tunnel_scene: PackedScene
@export_group("Dimensions")
@export var dungeon_width: int
@export var dungeon_height: int
@export var room_size: Vector3 = Vector3(10, 10, 10)
@export_group("Player")
@export var player_scene: PackedScene

var rooms: Array = []
var rooms_to_add: int
var added_rooms: int

func _ready() -> void:
	_generate_dungeon()
	add_child(player_scene.instantiate())
	
func _generate_dungeon():
	rooms = []
	rooms_to_add = randi_range(2, 8)
	added_rooms = 0
	
	for x in range(dungeon_height):
		var column = []
		for y in range(dungeon_width):
			var room = _place_room(x,y)
			column.append(room)
		rooms.append(column)
	for x in range(dungeon_height):
		for y in range(dungeon_width):
			var room = rooms[x][y]
			if room != null:
				var has_north_room = (y < dungeon_height -1) and (rooms[x][y+1] != null)
				var has_south_room = (y > 0) and (rooms[x][y-1] != null)
				var has_west_room = (x > 0) and (rooms[x-1][y] != null)
				var has_east_room = (x < dungeon_width -1) and (rooms[x+1][y] != null)
				
				set_door_and_wall_visibility(room, "North", has_north_room)
				set_door_and_wall_visibility(room, "South", has_south_room)
				set_door_and_wall_visibility(room, "West", has_west_room)
				set_door_and_wall_visibility(room, "East", has_east_room)

func set_door_and_wall_visibility(room: Node3D, cardinal_direction: String, has_room: bool):
	if has_room:
		room.get_node("Openings/{0}".format([cardinal_direction])).queue_free()

func _place_room(height: int, width: int) -> Node3D:
	var room_instance = basic_room_scene.instantiate()
	room_instance.transform.origin = Vector3(width * room_size.x, 0, height * room_size.z)
	$Rooms.add_child(room_instance)
	return room_instance

func _place_start_room():
	print("start")

func _place_end_room():
	print("end")

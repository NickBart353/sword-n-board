extends Node3D
@export var basic_room_scene: PackedScene
@export var basic_tunnel_scene: PackedScene
@export var dungeon_width: int
@export var dungeon_height: int
@export var room_size: Vector3 = Vector3(10, 10, 10)

var rooms: Array = []

func _ready() -> void:
	_generate_dungeon()
	
func _generate_dungeon():
	rooms = []
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
				var has_north_room = (y > 0) and (rooms[x][y-1] != null)
				var has_south_room = (x > 0) and (rooms[x-1][y] != null)
				var has_west_room = (y < dungeon_height -1) and (rooms[x][y+1] != null)
				var has_east_room = (x < dungeon_width -1) and (rooms[x+1][y] != null)

func _place_room(height: int, width: int) -> Node3D:
	var room_instance = basic_room_scene.instantiate()
	room_instance.transform.origin = Vector3(height * room_size.x, 0, width * room_size.z)
	add_child(room_instance)
	return room_instance

extends Node3D
class_name FoliageManager

@export var detailed_grass_scene: PackedScene
@export var grid_size: int = 3
@export var grid_section_size: int = 15
@export var foliage_container: Node3D
@export var terrain: Terrain3D

var player
var player_position_vec_two: Vector2 = Vector2.ZERO
var foliage_grid: Array[Array]
var start_grid: int
var end_grid: int
var current_center_grid: Vector2 = Vector2.ZERO

func _ready() -> void:
	start_grid = 0 - grid_size / 2
	end_grid = 0 + grid_size / 2
	player = get_tree().get_first_node_in_group("Player")
	for x in range(grid_size):
		foliage_grid.append([])
		for y in range(grid_size):
			var foliage_instance = detailed_grass_scene.instantiate()
			foliage_container.add_child(foliage_instance)
			foliage_grid[x].append(foliage_instance)
			foliage_instance._set_mat(terrain)
	_create_initial_grid()

func _process(delta: float) -> void:
	if _player_outside_center_grid():
		_reset_grid()

func _create_initial_grid():
	for x in range(foliage_grid.size()):
		for y in range(foliage_grid[x].size()):
			if x == 0 and y == 0:
				current_center_grid = Vector2(player.global_position.x, player.global_position.z)
			foliage_grid[x][y].global_position = player.global_position + Vector3((start_grid + x) * grid_section_size, 0, (start_grid + y) * grid_section_size)

func _player_outside_center_grid() -> bool:
	player_position_vec_two = Vector2(player.global_position.x, player.global_position.z)
	if player_position_vec_two.distance_to(current_center_grid) > 7.5:
		return true
	return false

func _reset_grid():
	var direction = player_position_vec_two.direction_to(current_center_grid)
	if direction.x > 0 and direction.y > 0:
		for x in range(foliage_grid.size()):
			for y in range(foliage_grid[x].size()):
				foliage_grid[x][y].global_position = foliage_grid[x][y].global_position + Vector3(0, 0, -grid_section_size)
				foliage_grid[x][y]._set_mat(terrain)
	elif direction.x < 0 and direction.y > 0:
		for x in range(foliage_grid.size()):
			for y in range(foliage_grid[x].size()):
				foliage_grid[x][y].global_position = foliage_grid[x][y].global_position + Vector3(grid_section_size, 0, 0)
				foliage_grid[x][y]._set_mat(terrain)
	elif direction.x > 0 and direction.y < 0:
		for x in range(foliage_grid.size()):
			for y in range(foliage_grid[x].size()):
				foliage_grid[x][y].global_position = foliage_grid[x][y].global_position + Vector3(-grid_section_size, 0, 0)
				foliage_grid[x][y]._set_mat(terrain)
	elif direction.x < 0 and direction.y < 0:
		for x in range(foliage_grid.size()):
			for y in range(foliage_grid[x].size()):
				foliage_grid[x][y].global_position = foliage_grid[x][y].global_position + Vector3(0, 0, +grid_section_size)
				foliage_grid[x][y]._set_mat(terrain)
	current_center_grid = Vector2(foliage_grid[grid_size / 2][grid_size / 2].global_position.x, foliage_grid[grid_size / 2][grid_size / 2].global_position.z)
	

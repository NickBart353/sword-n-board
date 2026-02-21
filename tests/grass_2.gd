extends MultiMeshInstance3D

var grid_size: int = 256

@export var terrain: Terrain3D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var current_region = terrain.data.get_regionp(global_position)
	var actual_height_map = get_visible_cutout(current_region)
	var tex: ImageTexture = ImageTexture.create_from_image(actual_height_map)
	var mat = material_override as ShaderMaterial
	mat.set_shader_parameter("height_map", tex)
	mat.set_shader_parameter("min_height", current_region.height_range.x)
	mat.set_shader_parameter("max_height", current_region.height_range.y)

func get_visible_cutout(region: Terrain3DRegion) -> Image:
	# 1. Get the local pixel coordinates within the region
	# We use floor to ensure we get a valid integer pixel index

	# 2. Extract the small slice of the heightmap
	var full_map: Image = region.height_map
	
	# Safety check to stay inside image bounds
	var raw_slice: Image = region.height_map
	
	# 3. Use the region's actual recorded range for normalization
	# This ensures the B&W mapping stays consistent with the shader
	var min_h: float = region.height_range.x
	var max_h: float = region.height_range.y
	var h_range = max_h - min_h
	if h_range == 0: h_range = 1.0

	# 4. Create the visible Grayscale image
	var bw_img = Image.create(grid_size, grid_size, false, Image.FORMAT_L8)

	for y in grid_size:
		for x in grid_size:
			var raw_val = raw_slice.get_pixel(x, y).r
			var norm_val = clamp((raw_val - min_h) / h_range, 0.0, 1.0)
			bw_img.set_pixel(x, y, Color(norm_val, norm_val, norm_val, 1.0))

	return bw_img

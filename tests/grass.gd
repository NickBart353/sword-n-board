#extends MultiMeshInstance3D
#var terrain: Terrain3D
#var grid_size: int = 15
#
#func _set_mat(terrain_node: Terrain3D):
	#terrain = terrain_node
	#if not terrain or not terrain.data:
		#return
#
	## 1. Get the correct region
	#var current_region = terrain.data.get_regionp(global_position)
	#if not current_region:
		#return
#
	## 2. Get the spacing (usually 1.0, but crucial if changed)
	#var spacing = terrain.vertex_spacing
#
	## 3. Calculate the local PIXEL position
	## world_origin is in meters. global_position is in meters.
	#var region_world_origin = Vector2(current_region.location) * float(current_region.region_size) * spacing
#
	## Distance from region start in pixels
	#var pixel_x = int((global_position.x - region_world_origin.x) / spacing)
	#var pixel_z = int((global_position.z - region_world_origin.y) / spacing)
#
	## 4. CENTER THE CUTOUT
	## If the mesh is at (pixel_x, pixel_z), we want 7 pixels to the left and 7 to the right
	#var half_grid = grid_size / 2
	#var start_x = pixel_x - half_grid
	#var start_z = pixel_z - half_grid
#
	## 5. Extract and assign
	#var img: Image = current_region.height_map
#
	## Ensure we don't sample outside the 1024x1024 image bounds
	#var region_rect = Rect2i(start_x, start_z, grid_size, grid_size)
	#var img_bounds = Rect2i(0, 0, img.get_width(), img.get_height())
#
	#if img_bounds.encloses(region_rect):
		#var cutout: Image = img.get_region(region_rect)
		#var tex: ImageTexture = ImageTexture.create_from_image(cutout)
#
		## IMPORTANT: If all grass patches look identical, you need to 
		## make sure each has its own material instance.
		#if material_override:
			## We create a unique copy so this patch doesn't overwrite others
			#var mat = material_override.duplicate() as ShaderMaterial
			#mat.set_shader_parameter("height_map", tex)
			#material_override = mat
		#else:
			#push_warning("Grass patch at ", global_position, " is outside region image bounds!")

extends MultiMeshInstance3D

var terrain: Terrain3D
var grid_size: int = 15
var last_region
var actual_height_map: Image

func _set_mat(terrain_node: Terrain3D):
	terrain = terrain_node
	if not terrain:
		return
	
	var current_region = terrain.data.get_region(Vector2i(int(self.global_position.x), int(self.global_position.z)))
	current_region = terrain.data.get_regionp(global_position)
	if not current_region:
		return
	
	var world_pos = Vector2(current_region.location) * float(current_region.region_size)
	var img: Image = current_region.height_map
	#if last_region != current_region:
	actual_height_map = get_visible_cutout(current_region, world_pos)
	
	var cutout: Image = actual_height_map.get_region(Rect2i(global_position.x - world_pos.x, global_position.z - world_pos.y, grid_size, grid_size))
	var tex: ImageTexture = ImageTexture.create_from_image(actual_height_map)
	
	var mat = material_override as ShaderMaterial
	
	mat.set_shader_parameter("height_map", tex)
	mat.set_shader_parameter("min_height", current_region.height_range.x)
	mat.set_shader_parameter("max_height", current_region.height_range.y)

func get_visible_cutout(region: Terrain3DRegion, region_origin: Vector2) -> Image:
	# 1. Get the local pixel coordinates within the region
	# We use floor to ensure we get a valid integer pixel index
	var local_x = int(floor(global_position.x - region_origin.x))
	var local_z = int(floor(global_position.z - region_origin.y))

	# 2. Extract the small slice of the heightmap
	var full_map: Image = region.height_map
	
	# Safety check to stay inside image bounds
	var rect = Rect2i(local_x, local_z, grid_size, grid_size)
	var raw_slice: Image = full_map.get_region(rect)
	
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

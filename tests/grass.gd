extends MultiMeshInstance3D

var terrain: Terrain3D

func _set_mat(terrain_node: Terrain3D):
	terrain = terrain_node
	if not terrain:
			return
	var current_region = terrain.data.get_region(Vector2i(self.global_position.x, self.global_position.z))
	if current_region:
		var tex: ImageTexture = ImageTexture.create_from_image(current_region.height_map)
		var size: int = current_region.region_size
		var world_pos = Vector2(current_region.location) * float(current_region.region_size)
	
		var mat = material_override as ShaderMaterial

		mat.set_shader_parameter("height_map", tex)
		mat.set_shader_parameter("terrain_size", float(size))
		mat.set_shader_parameter("region_world_pos", world_pos)
		mat.set_shader_parameter("height_range", current_region.height_range)

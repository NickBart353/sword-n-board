extends TextureRect

const L8_MAX := 255.0

@export var colormap: GradientTexture2D

func _ready() -> void:
	if not texture:
		return

	# In Godot 4, we generally don't await texture.changed in _ready 
	# unless the texture is being set asynchronously. 
	# If you need to ensure the image is loaded:
	if texture.get_image() == null:
		await texture.changed
	
	# Get the Image from the Texture2D resource
	var img: Image = texture.get_image()
	
	if img:
		var heightmap_minmax := _get_heightmap_minmax(img)
		
		if material is ShaderMaterial:
			material.set_shader_parameter("noise_minmax", heightmap_minmax)
			material.set_shader_parameter("colormap", _discrete(colormap))

func _get_heightmap_minmax(image: Image) -> Vector2:
	# Duplicate the image so we don't modify the original texture resource when converting
	var img_copy: Image = image.duplicate()
	img_copy.convert(Image.FORMAT_L8)
	return _get_minmax(img_copy.get_data()) / L8_MAX

func _get_minmax(data: PackedByteArray) -> Vector2:
	# Initialize with infinity
	var min_val: float = INF
	var max_val: float = -INF
	
	# Iterating over PackedByteArray is optimized in Godot 4
	for value in data:
		if value < min_val: min_val = value
		if value > max_val: max_val = value
		
	return Vector2(min_val, max_val)

func _discrete(gt: GradientTexture2D) -> ImageTexture:
	# Image.create syntax changed slightly (width, height, mipmaps, format)
	var image := Image.create(gt.width, 1, false, Image.FORMAT_RGBA8)
	
	var gradient := gt.gradient
	if not gradient:
		return ImageTexture.new()

	var point_count := gradient.get_point_count()
	var offsets := gradient.offsets
	var colors := gradient.colors

	# Loop logic preserved from original script
	var loop_count = (point_count - 1) if point_count > 1 else point_count
	
	for index in range(loop_count):
		var offset1: float = offsets[index]
		var offset2: float = offsets[index + 1] if point_count > 1 else 1.0
		var color: Color = colors[index]
		
		var start_x: int = int(gt.width * offset1)
		var end_x: int = int(gt.width * offset2)
		
		# Fill pixel range
		for x in range(start_x, end_x):
			# Safety check to prevent out of bounds errors
			if x < image.get_width():
				image.set_pixel(x, 0, color)

	# In Godot 4, this is a static method
	return ImageTexture.create_from_image(image)

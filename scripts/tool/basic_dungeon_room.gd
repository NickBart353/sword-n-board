@tool
extends Node3D

# These variables will appear in the Inspector
@export_group("Total Dimensions")
@export var total_size: Vector3:
	get:
		return calculate_size()
	set(value):
		pass # Read-only in inspector

@export var size_x: float:
	get:
		return calculate_size().x
	set(value):
		pass 

@export var size_z: float:
	get:
		return calculate_size().z
	set(value):
		pass

func calculate_size() -> Vector3:
	var combined_aabb: AABB = AABB()
	var first = true

	# We look at all children to find VisualInstance3D nodes (MeshInstance3D, CSG, etc.)
	# or other nodes that might have visual bounds.
	for child in find_children("*", "VisualInstance3D", true, false):
		if child.visible:
			# Get the child's AABB and transform it to global space, then back to local
			var child_aabb = child.get_aabb()
			var child_global_transform = child.global_transform
			
			# Transform corners to account for rotation/scale
			var corners = [
				child_aabb.position,
				child_aabb.position + Vector3(child_aabb.size.x, 0, 0),
				child_aabb.position + Vector3(0, child_aabb.size.y, 0),
				child_aabb.position + Vector3(0, 0, child_aabb.size.z),
				child_aabb.position + Vector3(child_aabb.size.x, child_aabb.size.y, 0),
				child_aabb.position + Vector3(child_aabb.size.x, 0, child_aabb.size.z),
				child_aabb.position + Vector3(0, child_aabb.size.y, child_aabb.size.z),
				child_aabb.end
			]

			for corner in corners:
				# Convert to global space, then relative to THIS parent node
				var global_point = child_global_transform * corner
				var local_point = to_local(global_point)

				if first:
					combined_aabb.position = local_point
					combined_aabb.size = Vector3.ZERO
					first = false
				else:
					combined_aabb = combined_aabb.expand(local_point)

	return combined_aabb.size

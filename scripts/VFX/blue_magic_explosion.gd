extends Basic_VFX

@export var mesh_to_remove: MeshInstance3D

func _remove_mesh():
	mesh_to_remove.hide()

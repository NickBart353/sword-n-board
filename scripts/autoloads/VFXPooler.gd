extends Node3D

var VFX_DICT: Dictionary = {
	VfxManager.VFX.BLOOD_SPLATTER: {
		"scene" : VfxManager.VFX_DICT.get(VfxManager.VFX.BLOOD_SPLATTER),
		"count" : 5,
		"container_name" : "BLOOD_SPLATTER",
		"array_container_number" : 0,
	}
}

var available_vfx_conainer: Array[Array] = []

func _ready() -> void:
	for vfx_name in VFX_DICT:
		var container: Node3D = Node3D.new()
		add_child(container)
		container.name = VFX_DICT.get(vfx_name).get("container_name")
		available_vfx_conainer.append([])
		VFX_DICT[vfx_name]["array_container_number"] = available_vfx_conainer.size() - 1
		for i in VFX_DICT.get(vfx_name).get("count"):
			var vfx_instance: Basic_VFX = VFX_DICT.get(vfx_name).get("scene").instantiate()
			container.add_child(vfx_instance)
			_deactivate_object(vfx_instance)

func reset_object(object: Variant) -> void:
	_deactivate_object(object)

func _deactivate_object(object: Basic_VFX) -> void:
	object.set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)
	object.global_position = Vector3(-10000, -10000, -10000)
	
	var key: VfxManager.VFX = _find_parent(object)
	
	available_vfx_conainer[VFX_DICT.get(key).get("array_container_number")].append(object)

func _find_parent(object: Basic_VFX) -> VfxManager.VFX:
	var parent_name: String = object.get_parent().name
	for key in VFX_DICT:
		if parent_name == VFX_DICT.get(key).get("container_name"):
			return key
	return VfxManager.VFX

func _create_new_sack() -> Basic_VFX:
	return null

func get_free_vfx(vfx_key: VfxManager.VFX) -> Basic_VFX:
	var vfx: Basic_VFX
	if available_vfx_conainer[VFX_DICT.get(vfx_key).get("array_container_number")].is_empty():
		print("NUlL VFX VFXPOOLER.gd")
		return _create_new_sack()
	else:
		vfx = available_vfx_conainer[VFX_DICT.get(vfx_key).get("array_container_number")].pop_back()
	vfx.set_deferred("process_mode", Node.PROCESS_MODE_INHERIT)
	return vfx

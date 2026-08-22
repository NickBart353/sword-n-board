@tool
class_name TorchEnchantApplicator extends EnchantApplicator

@export var fire_vfx: Node3D
@export var light: OmniLight3D

const vfx_color_dict: Dictionary = {
	WeaponData.UPGRADE_TYPE.FIRE: {
		"flame": Color(1.419, 0.772, 0.0, 1.0),
		"smoke": Color(0.119, 0.119, 0.119, 1.0),
		"particle": Color(1.951, 0.825, 0.0, 1.0),
		"light": Color(1.433, 0.65, 0.0),
	},
	WeaponData.UPGRADE_TYPE.COLD: {
		"flame": Color(0.677, 1.333, 2.503, 1.0),
		"smoke": Color(0.758, 0.758, 0.758, 1.0),
		"particle": Color(0.512, 0.639, 1.882, 1.0),
		"light": Color(0.0, 0.659, 1.433, 1.0),
	},
	WeaponData.UPGRADE_TYPE.CHAOS: {
		"flame": Color(1.116, 1.116, 1.116, 1.0),
		"smoke": Color(0.119, 0.119, 0.119, 1.0),
		"particle": Color(1.017, 0.016, 1.804, 1.0),
		"light": Color(0.475, 0.228, 0.809, 1.0),
	},
	WeaponData.UPGRADE_TYPE.LIGHTNING: {
		"flame": Color(0.469, 1.595, 2.603, 1.0),
		"smoke": Color(0.119, 0.119, 0.119, 1.0),
		"particle": Color(1.401, 1.557, 0.0, 1.0),
		"light": Color(1.381, 1.381, 0.388, 1.0),
	},
	WeaponData.UPGRADE_TYPE.NATURE: {
		"flame": Color(0.489, 1.188, 0.212, 1.0),
		"smoke": Color(0.119, 0.119, 0.119, 1.0),
		"particle": Color(1.025, 0.265, 0.636, 1.0),
		"light": Color(1.433, 0.117, 0.454, 1.0),
	},
}

func _apply_additional_effects() -> void:
	fire_vfx.update_all_colors(
		vfx_color_dict[upgrade_type]["flame"],
		vfx_color_dict[upgrade_type]["smoke"],
		vfx_color_dict[upgrade_type]["particle"],
	)
	light.light_color = vfx_color_dict[upgrade_type]["light"]

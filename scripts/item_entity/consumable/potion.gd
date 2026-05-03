class_name Potion extends Consumable

var property: String
var property_type: ConsumableData.PROPERTY_TYPE
var amount: float

@export var emitting_light: OmniLight3D

func set_data(new_data: ItemData):
	data = new_data
	if data is ConsumableData:
		if data.use_basic_attribute:
			property = data.player_property
			property_type = data.property_type
			amount = data.amount
		if data.model:
			var model_instance: Node3D = data.model.instantiate()
			model_instance.scale = Vector3(data.model_scale, data.model_scale, data.model_scale)
			add_child(model_instance)
		if data.use_light:
			emitting_light.omni_range = data.light_range
			emitting_light.light_color = data.light_color
			emitting_light.light_energy = data.light_energy
		else:
			emitting_light.hide()
			

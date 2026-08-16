extends InventoryItemText

@export var item_name: Label
@export var flavor_text: Label
@export var type: Label
@export var normal_value: Label
@export var magic_value: Label
@export var fire_value: Label
@export var lightning_value: Label
@export var cold_value: Label
@export var nature_value: Label
@export var chaos_value: Label

func _ready() -> void:
	hide()

func set_text(item: Item):
	item_name.text = item.data.get_combined_name()
	flavor_text.text = item.data.tooltip
	type.text = ItemData.get_item_type_value(item.data.item_type)
	#push_warning("fix this, weapon_text.gd")
	normal_value.text = item.data.normal_text
	fire_value.text = item.data.fire_text
	cold_value.text = item.data.cold_text
	lightning_value.text = item.data.lightning_text
	nature_value.text = item.data.nature_text
	chaos_value.text = item.data.chaos_text
	#_apply_text(item.data.damage_container.primary_damage)
	#for damage_resource in item.data.damage_container.additional_damage:
		#_apply_text(damage_resource)

#func _apply_text(damage_resource: DamageResource) -> void:
	#match damage_resource.damage_type:
		##WeaponData.UPGRADE_TYPE.MAGIC
			##magic_value.text = "{0}".format([damage_resource.damage_amount])
		#WeaponData.UPGRADE_TYPE.NORMAL:
		#WeaponData.UPGRADE_TYPE.FIRE:
		#WeaponData.UPGRADE_TYPE.COLD:
		#WeaponData.UPGRADE_TYPE.LIGHTNING:
		#WeaponData.UPGRADE_TYPE.NATURE:
		#WeaponData.UPGRADE_TYPE.CHAOS:

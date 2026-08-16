class_name InterfaceItemHorizontal extends PanelContainer

@onready var label: Label = $HBoxContainer/VBoxContainer/HBoxContainer/Label
@onready var label_2: Label = $HBoxContainer/VBoxContainer/Label2
@onready var label_3: Label = $HBoxContainer/VBoxContainer/Label3
@onready var texture_rect: TextureRect = $HBoxContainer/TextureRect
@onready var elemental_indicator: TextureRect = $HBoxContainer/VBoxContainer/HBoxContainer/ElementalIndicator

func set_data(itemdata: ItemData) -> void:
	label.text = itemdata.get_combined_name()
	label_2.text = itemdata.tooltip
	label_3.text = str(itemdata.stack_size)
	texture_rect.texture = itemdata.sprite
	if itemdata is WeaponData:
		elemental_indicator.show()
		match itemdata.upgrade_type:
			WeaponData.UPGRADE_TYPE.NORMAL:
				elemental_indicator.hide()
			WeaponData.UPGRADE_TYPE.FIRE:
				elemental_indicator.texture = SceneManager.UIItemIcons.get("flame_icon")
			WeaponData.UPGRADE_TYPE.COLD:
				elemental_indicator.texture = SceneManager.UIItemIcons.get("cold_icon")
			WeaponData.UPGRADE_TYPE.LIGHTNING:
				elemental_indicator.texture = SceneManager.UIItemIcons.get("lightning_icon")
			WeaponData.UPGRADE_TYPE.NATURE:
				elemental_indicator.texture = SceneManager.UIItemIcons.get("nature_icon")
			WeaponData.UPGRADE_TYPE.CHAOS:
				elemental_indicator.texture = SceneManager.UIItemIcons.get("chaos_icon")
	else:
		elemental_indicator.hide()

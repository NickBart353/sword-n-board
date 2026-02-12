extends RangedWeapon

func _ready() -> void:
	pass#data = preload("res://resources/items/iron_sword.tres")

func set_data(new_data: ItemData):
	super(new_data)

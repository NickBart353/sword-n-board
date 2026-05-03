@abstract
class_name MeleeWeapon extends Weapon

func _ready() -> void:
	print("{0}: Connect body entered signal!".format([self.name]))

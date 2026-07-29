@tool
class_name MobSpawn extends Marker3D

@export var spawn_id: String = ""
@export var button: bool = false : set = set_id
@export var disable_mob: bool = false

func set_id(new_value: bool) -> void:
	spawn_id = UuidGenerator.uuid4()

var is_my_mob_dead: bool = false

func _ready() -> void:
	add_to_group("MobSpawn")
	#is_my_mob_dead = false

func mob_died() -> void:
	CombatManager.remove_unit()
	is_my_mob_dead = true

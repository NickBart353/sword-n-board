class_name MobSpawn extends Marker3D

@export var spawn_id: String = ""
var is_my_mob_dead: bool

func _ready() -> void:
	add_to_group("MobSpawn")
	is_my_mob_dead = false

func mob_died() -> void:
	is_my_mob_dead = true

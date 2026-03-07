class_name MobSpawn extends Marker3D

var is_my_mob_dead: bool

func _ready() -> void:
	is_my_mob_dead = false

func mob_died() -> void:
	is_my_mob_dead = true

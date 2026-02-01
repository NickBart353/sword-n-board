@abstract
class_name Enemy extends CharacterBody3D

var level: int = 1

@abstract func take_damage(damage_dealt)

@abstract func force_engage()

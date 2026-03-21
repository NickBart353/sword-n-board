extends Area3D

@export var damage: int  = 20

@onready var anim_player: AnimationPlayer = $AnimationPlayer

signal slam_finished

var hit: bool = false

func _ready() -> void:
	monitoring = false
	hide()

func _process(_delta: float) -> void:
	if monitoring and not hit:
		for body in get_overlapping_bodies():
			if (body is Player or body is Enemy):
				hit = true
				body.take_damage(damage, self)

func play_slam(new_damage: int):
	damage = new_damage
	anim_player.play("slam")

func activate_slam():
	monitoring = true
	show()

func deactivate_slam():
	monitoring = false

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "slam":
		slam_finished.emit(self)
		anim_player.play("RESET")
		hide()

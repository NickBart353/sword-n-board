extends MeleeWeapon

@onready var anim_player = $AnimationPlayer
var is_attacking = false

var damage = 25

func play_animation():
	if anim_player.current_animation != "swang":
		anim_player.play("swang")

func check_existing_collisions():
	var areas = $Area3D.get_overlapping_areas()
	for area in areas:
		_on_area_3d_area_entered(area)

func set_attacking(status: bool):
	is_attacking = status
	if is_attacking:
		check_existing_collisions()

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	set_attacking(false)

func _on_area_3d_area_entered(area: Area3D) -> void:
		if is_attacking and area.get_parent() is Enemy:
			area.get_parent().take_damage(damage)

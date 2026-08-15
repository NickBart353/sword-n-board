class_name Attack extends Area3D

#@export var damage: int  = 20
@export var damage: DamageContainer

@export var anim_player: AnimationPlayer
@export var animation_name: String

signal finished

var hit: bool = false

func _ready() -> void:
	hide()
	monitoring = false
	if not anim_player.animation_finished.is_connected(_on_animation_player_animation_finished):
		anim_player.animation_finished.connect(_on_animation_player_animation_finished)
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

func attack(new_transform: Transform3D, new_damage: DamageContainer):
	show()
	damage = new_damage
	if new_transform:
		global_transform = new_transform
	anim_player.play(animation_name)

func activate_monitoring():
	monitoring = true

func disable_monitoring():
	monitoring = false

func _on_body_entered(body: Node3D) -> void:
	if not hit and (body is Player or body is Enemy):
		hit = true
		body.take_damage(damage, self)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == animation_name:
		anim_player.play("RESET")
		hide()
		hit = false
		finished.emit(self)

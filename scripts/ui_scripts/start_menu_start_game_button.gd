extends Button

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	pressed.connect(_play_animation)

func _play_animation():
	animation_player.play("slash")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "slash":
		animation_player.play("RESET")

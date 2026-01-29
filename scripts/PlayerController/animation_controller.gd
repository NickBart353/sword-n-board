extends Node

@onready var anim_player = $"../AnimationPlayer"

func apply_animations(input: Node, movement: Node, ability: Node, delta: float) -> void:
	var attack = ability.get_node_or_null("Attack")
	if attack:
		if attack.swinging and not anim_player.is_playing():
			anim_player.play("Sword{0}".format([attack.swing]))

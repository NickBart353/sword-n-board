extends Node

@onready var anim_player = $"../AnimationPlayer"
@onready var anim_tree = $"../AnimationTree"["parameters/playback"]

func apply_animations(input: Node, movement: Node, ability: Node, delta: float) -> void:
	if input.dash:
		var attack = ability.get_node_or_null("Attack")
		if attack:
			if attack.swinging and not anim_player.is_playing():
				anim_tree.travel("Sword{0}".format([attack.swing]))
				#anim_player.play("Sword{0}".format([attack.swing]))

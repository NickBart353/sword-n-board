extends Node

@onready var anim_player = $"../AnimationPlayer"
@onready var anim_tree = $"../AnimationTree"
@onready var anim_tree_list = $"../AnimationTree"["parameters/playback"]

func apply_animations(input: Node, movement: Node, ability: Node, delta: float) -> void:
	if not input.dash:
		var attack = ability.get_node_or_null("Attack")
		if attack:
			if attack.swinging:
				anim_tree_list.travel("Sword{0}".format([attack.swing]))
		var cast_attack = ability.get_node_or_null("CastAttack")
		if cast_attack:
			if cast_attack.casting:
				anim_tree_list.travel("Book{0}".format([cast_attack.cast]))

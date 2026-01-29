extends Node

@onready var anim_player = $"../AnimationPlayer"

func apply_animations(input: Node, movement: Node, ability: Node, delta: float) -> void:
	var attack = ability.get_node_or_null("Attack")
	if attack:
		if attack.swing_three:
			anim_player.play("Sword3")
		elif attack.swing_two:
			anim_player.play("Sword2")
		elif attack.swing_one:
			anim_player.play("Sword1")
		

extends Node

@onready var anim_player = $"../AnimationPlayer"
@onready var anim_tree = $"../AnimationTree"
@onready var anim_tree_list = $"../AnimationTree"["parameters/playback"]

var attack: Node
var cast_attack: Node
var shoot_attack: Node
var block_attack: Node
var light: Node

func apply_animations(input: Node, movement: Node, ability: Node, delta: float) -> void:
	if not input.dash:
		attack = ability.get_node_or_null("Attack")
		if attack:
			if attack.swinging:
				anim_tree_list.travel("Sword{0}".format([attack.swing]))
		cast_attack = ability.get_node_or_null("CastAttack")
		if cast_attack:
			if cast_attack.casting:
				anim_tree_list.travel("Book{0}".format([cast_attack.cast]))
		shoot_attack = ability.get_node_or_null("ShootAttack")
		if shoot_attack:
			if shoot_attack.shooting:
				anim_tree_list.travel("Bow{0}".format([shoot_attack.shoot]))
		block_attack = ability.get_node_or_null("Block")
		if block_attack:
			if block_attack.blocking:
				anim_tree_list.travel("Block1")
		light = ability.get_node_or_null("Light")
		if light:
			if light.lighting:
				anim_tree_list.travel("Light1")

extends Node

@onready var anim_player = $"../AnimationPlayer"
@onready var anim_tree = $"../AnimationTree"
@onready var anim_tree_list = $"../AnimationTree"["parameters/playback"]

var attack: Node
var cast_attack: Node
var shoot_attack: Node
var block_attack: Node
var light: Node
var consume: Node

func apply_animations(input: Node, state_controller: Node, movement: Node, ability: Node, delta: float) -> void:
	if not input.dash:
		if not attack:
			attack = ability.get_node_or_null("Attack")
		if attack.swinging:
			anim_tree_list.travel("Sword{0}".format([attack.swing]))
		if not cast_attack:
			cast_attack = ability.get_node_or_null("CastAttack")
		if cast_attack.casting:
			anim_tree_list.travel("Book{0}".format([cast_attack.cast]))
		if not shoot_attack:
			shoot_attack = ability.get_node_or_null("ShootAttack")
		if shoot_attack.shooting:
			anim_tree_list.travel("Bow{0}".format([shoot_attack.shoot]))
		if not block_attack:
			block_attack = ability.get_node_or_null("Block")
		if block_attack.blocking:
			anim_tree_list.travel("Block1")
		if not light:
			light = ability.get_node_or_null("Light")
		if light.lighting:
			anim_tree_list.travel("Light1")
		if not consume:
			consume = ability.get_node_or_null("Consume")
		if consume.consuming:
			anim_tree_list.travel("Consume1")

class_name EnemyAttack extends EnemyAbility

@export var damage: int = 1
@export var attack_scene: PackedScene
@export var attack_position: Node
@export var attack_rotation: Basis = Basis()

var attack_instance: Attack

func _ready() -> void:
	attack_instance = attack_scene.instantiate()
	enemy.add_child.call_deferred(attack_instance)
	if not attack_instance.finished.is_connected(_attack_finished):
		attack_instance.finished.connect(_attack_finished)

func _attack_finished(_object: Node):
	cool_down_timer.start()
	Transitioned.emit(self, "Follow")

func Enter():
	super()
	var new_transform: Transform3D
	#if attack_rotation:
		#new_transform = Transform3D(attack_rotation, attack_position.global_position)
	#else:
	new_transform = Transform3D(attack_position.transform)
	attack_instance.attack(new_transform, damage)

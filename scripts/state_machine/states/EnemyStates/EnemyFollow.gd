extends EnemyState

@export var follow_speed: float = 1
@export var attack_range: float = 0
@export var follow_range: float = 50
@export var look_at_player: bool = true

var ability_states: Array[Node]

func Enter():
	super()
	ability_states = get_children()
	for ability in ability_states:
		ability.set_values(player, enemy, attack_range)

func Exit():
	super()

func Physics_Update(delta: float) -> void:
	super(delta)
	if look_at_player:
		enemy.look_at(player.global_position, Vector3.UP, true)
	
	var distance = player.global_position - enemy.global_position
	
	enemy.velocity = enemy.global_position.direction_to(player.global_position) * follow_speed
	
	if distance.length() > follow_range:
		CombatManager.remove_unit(enemy.spawn_id)
		Transitioned.emit(self, "Idle")
		return
	for ability in ability_states:
		if ability.ready_to_use():
			Transitioned.emit(self, ability.name)
			return

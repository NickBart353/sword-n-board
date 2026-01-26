extends StateMachine

func _ready() -> void:
	for child in get_children():
		if child is EnemyState:
			states[child.name.to_lower()] = child
			child.Transitioned.connect(on_child_transitioned)
			child.Died.connect(on_child_died)
	if initial_state:
		initial_state.Enter()
		current_state = initial_state

func _process(delta: float) -> void:
	super(delta)

func _physics_process(delta: float) -> void:
	super(delta)

func on_child_transitioned(state, new_state_name):
	super(state, new_state_name)

func on_child_died(state):
	pass

extends PlayerState

@export var jump_velocity: int = 10

func Enter() -> void:
	super()

func Exit() -> void:
	super()

func Update(delta: float) -> void:
	super(delta)

func Physics_Update(delta: float) -> void:
	super(delta)
	
	if player.input.jump and player.is_on_floor():
		player.velocity.y = jump_velocity
		Transitioned.emit(self, "Airborne")
		return
	elif not player.is_on_floor():
		Transitioned.emit(self, "Airborne")
		return
	
	if player.input.dash:
		Transitioned.emit(self, "Dashing")
		return
	
	if player.input.freefly:
		pass
	
	if player.input.primary:
		Transitioned.emit(self, "Attack")
		return
	
	if player.input.secondary:
		Transitioned.emit(self, "Secondary")
		return
	
	if player.input.ability_one: 
		pass
	
	if player.input.ability_two: 
		pass
	
	if player.input.ability_three: 
		pass
	
	var move_dir := (player.transform.basis * Vector3(player.input.direction.x, 0, player.input.direction.y)).normalized()
	if move_dir:
		player.velocity.x = move_dir.x * player.movement_speed
		player.velocity.z = move_dir.z * player.movement_speed
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.movement_speed)
		player.velocity.z = move_toward(player.velocity.z, 0, player.movement_speed)
	

func _on_attack_timer_timeout() -> void:
	if state_active:
		$"../Attack".combo = 0

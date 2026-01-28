extends PlayerState

func Enter() -> void:
	super()

func Exit() -> void:
	super()

func Update(delta: float) -> void:
	super(delta)

func Physics_Update(delta: float) -> void:
	super(delta)
	
	if player.is_on_floor():
		Transitioned.emit(self, "Default")
		return
	else:
		player.velocity += player.get_gravity() * delta
	
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
	
	var move_dir := (player.transform.basis * Vector3(player.input.direction.x, 0, player.input.direction.y)).normalized()
	if move_dir:
		player.velocity.x = move_dir.x * player.movement_speed
		player.velocity.z = move_dir.z * player.movement_speed
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.movement_speed)
		player.velocity.z = move_toward(player.velocity.z, 0, player.movement_speed)

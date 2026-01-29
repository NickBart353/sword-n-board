extends PlayerState

@onready var anim_player: AnimationPlayer = $"../../AnimationPlayer"

var combo: int = 0
var weapon: Node
var bodies: Array
var animation_finished: bool

func Enter() -> void:
	super()
	$"../../Timers/AttackTimer".start()
	bodies = []
	combo += 1
	weapon = player.get_equipped_primary()
	if weapon:
		match weapon.name:
			"Bow":
				pass#anim_player.play(weapon)
			"Staff":
				pass#anim_player.play("{0}{1}".format([weapon, combo]))
			"Sword":
				if not weapon.hit.is_connected(_melee_attack):
					weapon.hit.connect(_melee_attack)
				anim_player.play("{0}1".format([weapon.name]))

func Exit() -> void:
	super()
	animation_finished = false
	match weapon.name:
		"Bow":
			combo = 0
		"Staff":
			if combo == 2:
				combo = 0
		"Sword":
			if combo == 3:
				combo = 0

func Update(delta: float) -> void:
	super(delta)

func Physics_Update(delta: float) -> void:
	super(delta)
	if animation_finished:
		Transitioned.emit(self, "Default")
	
	if player.input.inventory: 
		pass
	
	if player.input.pause_menu: 
		pass

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	pass
	#match weapon.name:
		#"Bow":
			#if anim_name == weapon.name:
				#Transitioned.emit(self, "Default")
				#animation_finished = true
		#"Staff":
			#if anim_name == "{0}{1}".format([weapon.name, combo]):
				#Transitioned.emit(self, "Default")
				#animation_finished = true
		#"Sword":
			#if anim_name == "{0}1".format([weapon.name]):
				#Transitioned.emit(self, "Default")
				#animation_finished = true

func _melee_attack(body, damage):
	if not body in bodies:
		body.take_damage(weapon.damage)
		bodies.append(body)

extends PlayerState

@onready var anim_player: AnimationPlayer = $"../../AnimationPlayer"

var combo: int = 0
var weapon_type: String

func Enter() -> void:
	super()
	$"../../Timers/AttackTimer".start()
	combo += 1
	weapon_type = player.get_equipped_primary()
	match weapon_type:
		"Bow":
			pass#anim_player.play(weapon_type)
		"Staff":
			pass#anim_player.play("{0}{1}".format([weapon_type][combo]))
		"Sword":
			anim_player.play("{0}1".format([weapon_type]))

func Exit() -> void:
	super()
	match weapon_type:
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
	Transitioned.emit(self, "Default")
	
	if player.input.inventory: 
		pass
	
	if player.input.pause_menu: 
		pass

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if state_active:
		match weapon_type:
			"Bow":
				if anim_name == weapon_type:
					Transitioned.emit(self, "Default")
			"Staff":
				if anim_name == "{0}{1}".format([weapon_type][combo]):
					Transitioned.emit(self, "Default")
			"Sword":
				if anim_name == "{0}{1}".format([weapon_type][combo]):
					Transitioned.emit(self, "Default")
		

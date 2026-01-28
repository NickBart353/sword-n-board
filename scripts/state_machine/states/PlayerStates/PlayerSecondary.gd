extends PlayerState

@onready var anim_player: AnimationPlayer = $"../../AnimationPlayer"

var weapon_type: String

func Enter() -> void:
	super()
	weapon_type = player.get_equipped_primary()
	#anim_player.play("{0}Secondary".format([weapon_type]))

func Exit() -> void:
	super()

func Update(delta: float) -> void:
	super(delta)

func Physics_Update(delta: float) -> void:
	super(delta)
	Transitioned.emit(self, "Default")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	Transitioned.emit(self, "Default")
		

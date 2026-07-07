class_name EnemyDied extends EnemyState

signal died

@export var death_timer: Timer

var particle_dissolve: Basic_VFX

func _ready() -> void:
	particle_dissolve = VfxManager.create_vfx_from_enum(VfxManager.VFX.BIG_KILL_PARTICLE, enemy.global_position, true).instantiate()
	add_child.call_deferred(particle_dissolve)

func Enter():
	super()
	#print("in combat: ", CombatManager.is_in_combat(), "; count: ", CombatManager.combat_units, "; state: ", name)
	AudioManager.play_audio_from_resource(audio_resource, enemy.global_position, AudioManager.BUS.SFX, offset_audio, audio_volume, audio_max_range)
	death_timer.start()
	if not death_timer.timeout.is_connected(_on_death_remove_timer_timeout):
		death_timer.timeout.connect(_on_death_remove_timer_timeout)
	enemy.set_collision_layer_value(4, false)
	anim_tree.tree_root = anim_tree.tree_root.duplicate(true)
	anim_tree.set("parameters/Dissolve/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	particle_dissolve.play()
	particle_dissolve.global_position = enemy.global_position

func Exit():
	super()

func Physics_Update(_delta: float) -> void:
	super(_delta)
	enemy.velocity += enemy.get_gravity()

func _on_death_remove_timer_timeout() -> void:
	died.emit()

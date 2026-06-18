extends State
class_name EnemyState

var player
@export var enemy: CharacterBody3D
@export var anim_tree: AnimationTree
@export var audio_player: AudioStreamPlayer3D
@onready var state_machine_resource = anim_tree.tree_root.get_node("Main") as AnimationNodeStateMachine
@onready var state_machine = anim_tree["parameters/Main/playback"]
@export_group("Audio")
@export var play_audio: bool = false
@export var audio_resource: AudioStream
@export_range(-100.0, 100.0) var offset_audio: float = 0.0
@export_range(-100.0, 100.0) var audio_volume: float = 0.0
@export_range(-100.0, 1000.0) var audio_max_range: float = 0.0 

func Enter():
	super()
	player = get_tree().get_first_node_in_group("Player")
	state_machine.travel(name)
	if audio_player and audio_resource and play_audio:
		audio_player.volume_db = audio_volume
		audio_player.max_distance = audio_max_range
		audio_player.stream = audio_resource
		audio_player.play(offset_audio)

func Exit():
	super()
	enemy.velocity = Vector3.ZERO

func Update(_delta: float) -> void:
	super(_delta)
	if enemy.health <= enemy.MIN_HEALTH and name != "Dead":
		Transitioned.emit(self, "Dead")

func Physics_Update(_delta: float) -> void:
	super(_delta)
	if not player:
		player = get_tree().get_first_node_in_group("Player")
		return

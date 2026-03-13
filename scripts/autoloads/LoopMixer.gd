extends Node

enum AREA {FOREST, BEACH}

var loop_dict: Dictionary = {
	AREA.FOREST : preload("res://assets/Audio/Free Fantasy SFX Pack By TomMusic/OGG Files/BGS Loops/Forest Day/Forest Day.ogg"),
	AREA.BEACH : preload("res://assets/Audio/pixabay/soundangel1111-ocean-beach-waves-332383.mp3"),
}

var current_area: AREA

@onready var player_one: AudioStreamPlayer = AudioStreamPlayer.new()
@onready var player_two: AudioStreamPlayer = AudioStreamPlayer.new()

func _ready() -> void:
	add_child(player_one)
	add_child(player_two)
	player_one.bus = "Music"
	player_two.bus = "Music"
	player_one.volume_db = -80.0
	player_two.volume_db = -80.0

func transition_to_new_area(new_area: AREA):
	if current_area and current_area == new_area:
		return
	
	var stream = loop_dict.get(new_area)
	
	var active_player = player_one if player_one.playing else player_two
	var target_player = player_two if player_one.playing else player_one
	
	target_player.stream = stream
	target_player.volume_db = -80.0
	target_player.play()
	
	var tween = create_tween().set_parallel(true)
	
	tween.tween_property(target_player, "volume_db", 0.0, 3.0).set_trans(Tween.TRANS_SINE)
	
	if active_player.playing:
		tween.tween_property(active_player, "volume_db", -80.0, 3.0).set_trans(Tween.TRANS_SINE)
		tween.chain().step_finished.connect(func(_idx): active_player.stop())

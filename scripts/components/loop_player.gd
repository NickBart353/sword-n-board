class_name LoopPlayer extends AudioStreamPlayer3D

func _ready() -> void:
	$"../StateMachine/Dead".died.connect(_stop_player)

func _stop_player():
	stop()

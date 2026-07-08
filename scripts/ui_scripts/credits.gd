class_name CreditScreen extends PanelContainer

@onready var scrollcontainer: ScrollContainer = $VBoxContainer/Scrollcontainer
@onready var anim_player: AnimationPlayer = $AnimationPlayer

@export_range(0.0, 10000.0) var scroll_speed: float = 100.0

signal leave_credits

var last_scroll: float
var _stopped: bool = false

func _ready() -> void:
	_hide_everything()
	_stopped = true
	last_scroll = 0
	scrollcontainer.scroll_vertical = 0

func start_scrolling() -> void:
	#_stopped = false
	_hide_everything()
	anim_player.play("start")

func _process(_delta: float) -> void:
	if not _stopped:
		scrollcontainer.scroll_vertical += scroll_speed
		if last_scroll == scrollcontainer.scroll_vertical:
			_stopped = true
		last_scroll = scrollcontainer.scroll_vertical

func _finished() -> void:
	_stopped = true
	last_scroll = 0
	scrollcontainer.scroll_vertical = 0
	leave_credits.emit()

#func _input(event: InputEvent) -> void:
	#if event is InputEventKey:
		#if event.keycode == KEY_ESCAPE:
			#_finished()

func _unhide_everything() -> void:
	$VBoxContainer/Scrollcontainer/MainContainer/GridContainer.show()
	$VBoxContainer/Scrollcontainer/MainContainer/Table.show()
	$VBoxContainer/Scrollcontainer/MainContainer/Godot.show()
	$VBoxContainer/Scrollcontainer/MainContainer/TextureRect.show()
	$VBoxContainer/Scrollcontainer/MainContainer/GodotLicense.show()

func _hide_everything() -> void:
	$VBoxContainer/Scrollcontainer/MainContainer/GridContainer.hide()
	$VBoxContainer/Scrollcontainer/MainContainer/Table.hide()
	$VBoxContainer/Scrollcontainer/MainContainer/Godot.hide()
	$VBoxContainer/Scrollcontainer/MainContainer/TextureRect.hide()
	$VBoxContainer/Scrollcontainer/MainContainer/GodotLicense.hide()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "start":
		_stopped = false
		_unhide_everything()

func _on_button_pressed() -> void:
	_finished()

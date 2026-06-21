class_name CreditScreen extends PanelContainer

@onready var scrollcontainer: ScrollContainer = $Scrollcontainer

@export_range(0.0, 10000.0) var scroll_speed: float = 100.0

signal leave_credits

var last_scroll: float
var _stopped: bool = false

func _ready() -> void:
	_stopped = true
	last_scroll = 0
	scrollcontainer.scroll_vertical = 0

func start_scrolling() -> void:
	_stopped = false

func _process(_delta: float) -> void:
	if not _stopped:
		scrollcontainer.scroll_vertical += scroll_speed
		if last_scroll == scrollcontainer.scroll_vertical:
			_finished()
		last_scroll = scrollcontainer.scroll_vertical

func _finished() -> void:
	_stopped = true
	last_scroll = 0
	scrollcontainer.scroll_vertical = 0
	leave_credits.emit()

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_ESCAPE:
			_finished()

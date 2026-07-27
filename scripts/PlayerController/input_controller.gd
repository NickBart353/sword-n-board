extends Node

var direction: Vector2
var jump: bool
var dash: bool
var freefly: bool
var primary: bool
var hold_primary: bool
var secondary: bool
var hold_secondary: bool
var attack: bool
var consume: bool
var inventory: bool
var pause_menu: bool
var interact: bool
var ability_one: bool
var ability_two: bool
var ability_three: bool

var skip_one: bool
var skip_process_once: bool

var block_input_by_player: bool = false

func _process(_delta: float) -> void:
	if PlayerControls.input_blocked():
		if skip_process_once:
			skip_process_once = false
			return
		interact = Input.is_action_just_pressed("Interact")
		if interact:
			PlayerControls.close_open_menus()
			interact = false
			skip_one = true

func block_input() -> void:
	block_input_by_player = true

func unblock_input() -> void:
	block_input_by_player = false

func get_input(_delta: float):
	if skip_one:
		skip_one = false
		return
	
	if block_input_by_player:
		return
	
	interact = Input.is_action_just_pressed("Interact")
	if PlayerControls.input_blocked():
		direction = Vector2.ZERO
		jump = false
		dash = false
		primary = false
		hold_primary = false
		attack = false
		secondary = false
		hold_secondary = false
		consume = false
		return
	if interact:
		skip_process_once = true
	direction = Input.get_vector("Move Left", "Move Right", "Move Forward", "Move Backward")
	jump = Input.is_action_just_pressed("Jump")
	dash = Input.is_action_just_pressed("Dash")
	primary = Input.is_action_just_pressed("Primary")
	hold_primary = Input.is_action_pressed("Primary")
	attack = Input.is_action_just_pressed("Primary")
	secondary = Input.is_action_just_pressed("Secondary")
	hold_secondary = Input.is_action_pressed("Secondary")
	consume = Input.is_action_just_pressed("Consume")

extends Node

var direction: Vector2
var jump: bool
var dash: bool
var freefly: bool
var primary: bool
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

func get_input(_delta: float):
	if not UiController.is_ui_open():
		#direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		#jump = Input.is_action_just_pressed("jump")
		#dash = Input.is_action_just_pressed("dash")
		#freefly = Input.is_action_just_pressed("freefly")
		#primary = Input.is_action_just_pressed("primary")
		#attack = Input.is_action_pressed("primary")
		#secondary = Input.is_action_just_pressed("seconday")
		#hold_secondary = Input.is_action_pressed("seconday")
		#consume = Input.is_action_just_pressed("consume")
		#ability_one = Input.is_action_just_pressed("ability_one")
		#ability_two = Input.is_action_just_pressed("ability_two")
		#ability_three = Input.is_action_just_pressed("ability_three")
		#inventory = Input.is_action_just_pressed("inventory")
		#interact = Input.is_action_just_pressed("interact")
		direction = Input.get_vector("Move Left", "Move Right", "Move Forward", "Move Backward")
		jump = Input.is_action_just_pressed("Jump")
		dash = Input.is_action_just_pressed("Dash")
		primary = Input.is_action_just_pressed("Primary")
		attack = Input.is_action_just_pressed("Primary")
		secondary = Input.is_action_just_pressed("Secondary")
		hold_secondary = Input.is_action_pressed("Secondary")
		consume = Input.is_action_just_pressed("Consume")
		interact = Input.is_action_just_pressed("Interact")
		inventory = Input.is_action_just_pressed("Open Inventory")

	#pause_menu = Input.is_action_just_pressed("pause")

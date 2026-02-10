extends Node

var direction: Vector2
var jump: bool
var dash: bool
var freefly: bool
var primary: bool
var secondary: bool
var attack: bool
var inventory: bool
var pause_menu: bool
var interact: bool
var ability_one: bool
var ability_two: bool
var ability_three: bool

func get_input(_delta: float):
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	jump = Input.is_action_just_pressed("jump")
	dash = Input.is_action_pressed("dash")
	freefly = Input.is_action_just_pressed("freefly")
	primary = Input.is_action_just_pressed("primary")
	attack = Input.is_action_pressed("primary")
	secondary = Input.is_action_just_pressed("seconday")
	inventory = Input.is_action_just_pressed("inventory")
	pause_menu = Input.is_action_just_pressed("pause")
	interact = Input.is_action_just_pressed("interact")
	ability_one = Input.is_action_just_pressed("ability_one")
	ability_two = Input.is_action_just_pressed("ability_two")
	ability_three = Input.is_action_just_pressed("ability_three")

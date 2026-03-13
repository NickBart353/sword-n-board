extends Node
class_name StateController

var current_movement_state: MOVEMENT_STATE = MOVEMENT_STATE.IDLE
var current_action_state: ACTION_STATE = ACTION_STATE.IDLE
var current_ui_state: UI_STATE = UI_STATE.IDLE

enum MOVEMENT_STATE {IDLE, WALKING, DASHING, JUMPING}
enum ACTION_STATE {IDLE, ATTACK, CASTING, SHOOTING, BLOCKING, LIGHTING, CONSUMING}
enum UI_STATE {IDLE, INVENTORY, ITEM_CONTAINER}

func update_movement_state(state: MOVEMENT_STATE):
	current_movement_state = state

func update_action_state(state: ACTION_STATE):
	current_action_state = state

func reset_movement_state():
	update_movement_state(StateController.MOVEMENT_STATE.IDLE)

func reset_action_state():
	update_action_state(StateController.ACTION_STATE.IDLE)

func ui_open():
	return not current_ui_state == UI_STATE.IDLE

func is_player_busy() -> bool:
	match current_movement_state:
		MOVEMENT_STATE.DASHING:
			return true
		MOVEMENT_STATE.IDLE, MOVEMENT_STATE.WALKING, MOVEMENT_STATE.JUMPING, _:
			pass
	
	match current_action_state:
		ACTION_STATE.ATTACK, ACTION_STATE.CASTING, ACTION_STATE.SHOOTING, ACTION_STATE.BLOCKING, ACTION_STATE.LIGHTING, ACTION_STATE.CONSUMING:
			return true
		ACTION_STATE.IDLE, _:
			pass
	return false

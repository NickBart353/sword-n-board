extends Node
class_name StateController

var current_state: STATE

enum STATE {IDLE, WALKING, DASHING, JUMPING, 
			ATTACKING, CASTING, SHOOTING, 
			BLOCKING, LIGHTING,
			CONSUMING, }

func update_state(state: STATE):
	current_state = state

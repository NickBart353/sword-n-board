extends Node3D
class_name HealthBar

@onready var healthbar = $Container/SubViewport/RedBar/HealthBar

func set_max_vals(max_val: int):
	healthbar.max_value = max_val
	update_health(max_val)

func update_health(val: int):
	healthbar.value = val
	if healthbar.value == 0:
		hide()

func reset_health():
	update_health(healthbar.max_value)

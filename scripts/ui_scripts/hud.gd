extends Control

@onready var health_bar: ProgressBar = $PlayerResourceContainer/HealthMargin/HealthBar
@onready var stamina_bar: ProgressBar = $PlayerResourceContainer/StaminaMargin/StaminaBar
@onready var mana_bar: ProgressBar = $PlayerResourceContainer/ManaMargin/ManaBar

func update_health(health: float):
	health_bar.value = health

func update_stamina(stamina: float):
	stamina_bar.value = stamina

func update_mana(mana: float):
	mana_bar.value = mana

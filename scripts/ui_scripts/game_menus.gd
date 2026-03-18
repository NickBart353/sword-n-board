extends CanvasLayer

@onready var hud: Control = $Hud
@onready var item_controller: Control = $ItemController
@onready var escape_menu: Control = $EscapeMenu

func _ready() -> void:
	UiController.inventory.connect(_inventory)
	UiController.character_panel.connect(_character_panel)
	UiController.lootbag.connect(_lootbag)
	UiController.game_menu.connect(_game_menu)
	UiController._update_healthbar.connect(_update_healthbar)
	UiController._update_staminabar.connect(_update_staminabar)
	UiController._update_manabar.connect(_update_manabar)
	UiController._update_hud.connect(_update_hud)
	
func _inventory():
	pass

func _character_panel():
	pass

func _lootbag():
	pass

func _game_menu():
	pass

func _update_healthbar(health: float):
	hud.update_health(health)

func _update_staminabar(stamina: float):
	hud.update_stamina(stamina)

func _update_manabar(mana: float):
	hud.update_mana(mana)

func _update_hud():
	pass

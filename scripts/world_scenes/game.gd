extends Main

func _ready() -> void:
	for enemy in $Mobs.get_children():
		enemy.died.connect(_enemy_died)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _enemy_died(enemy: Node3D):
	_generate_loot_on_enemy_death(enemy.global_position, enemy.level)

func _generate_loot_on_enemy_death(loot_position: Vector3, enemy_level):
	var items_to_generate: Array = ItemManager.generate_loot(enemy_level)
	if not items_to_generate: return
	var item_sack_instance = ITEM_SACK.instantiate()
	item_sack_instance.transform.origin = loot_position
	item_sack_instance.items = items_to_generate
	$Loot.add_child(item_sack_instance)

class_name SaveFile extends Resource

@export var save_id: String
@export var character_name: String
@export var creation_date: String

@export var health: float
@export var stamina: float
@export var mana: float
@export var position: Vector3
@export var rotation: Vector3
@export var spirit: int

@export var player_items: Array[ItemData]
@export var head: ItemData
@export var body: ItemData
@export var boots: ItemData
@export var mainhand: ItemData
@export var offhand: ItemData
@export var consumable: ItemData
@export var consumable_list: Array[ItemData]
@export var equipped_consumable_list: Array[ItemData]

@export var dead_mobs: Dictionary[String, bool]

@export var chest_items: Dictionary[String, Array]

@export var world_events: Dictionary[String, bool]

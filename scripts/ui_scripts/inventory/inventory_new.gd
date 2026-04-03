extends PanelContainer

var player_items: Array = []

@onready var all: GridContainer = $MarginContainer/Inventory/ItemContainer/All

@onready var weapon_text: ScrollContainer = $MarginContainer/Inventory/Right/StatContainer/ItemStatMargin/ItemPanel/_InsideMargin/WeaponScroller
@onready var consumable_text: ScrollContainer = $MarginContainer/Inventory/Right/StatContainer/ItemStatMargin/ItemPanel/_InsideMargin/ConsumableScroller

@onready var display_viewport: TextureRect = $MarginContainer/Inventory/Right/StatContainer/ItemDisplayMargin/DisplayPanel/_InsideMargin/DisplayViewport

@export var inventory_item_scene: PackedScene

func _ready() -> void:
	hide()
	UiController.update_player_items.connect(_update_player_items)
	UiController.get_player_items.call_deferred()

func get_player_items():
	UiController.get_player_items()

func _update_player_items(updated_player_items: Array):
	if not player_items == updated_player_items:
		player_items = updated_player_items
		
		for item in player_items:
			var inventory_item = inventory_item_scene.instantiate()
			inventory_item.item_hovered.connect(update_item_display)
			inventory_item.item_pressed.connect(activate_item)
			inventory_item.set_data(item)
			all.add_child(inventory_item)

func update_item_display(item: Item):
	match item.data.item_category:
		ItemData.ITEM_CATEGORY.MELEE_WEAPON, ItemData.ITEM_CATEGORY.RANGED_WEAPON, ItemData.ITEM_CATEGORY.MAGIC_WEAPON:
			weapon_text.show()
			consumable_text.hide()
			weapon_text.set_text(item)
		ItemData.ITEM_CATEGORY.CONSUMABLE:
			weapon_text.hide()
			consumable_text.show()
			consumable_text.set_text(item)
			
	display_viewport.texture = item.data.sprite

func activate_item(item: Item):
	pass

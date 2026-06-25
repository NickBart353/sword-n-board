extends HBoxContainer

@onready var weapon_scroller: InventoryItemText = $ItemStatMargin/ItemPanel/_InsideMargin/WeaponStats
@onready var armor_scroller: ScrollContainer = $ItemStatMargin/ItemPanel/_InsideMargin/ArmorScroller
@onready var consumable_scroller: InventoryItemText = $ItemStatMargin/ItemPanel/_InsideMargin/Consumable
@onready var material_scroller: InventoryItemText = $ItemStatMargin/ItemPanel/_InsideMargin/Material

#@onready var display_viewport: TextureRect = $ItemDisplayMargin/DisplayPanel/_InsideMargin/DisplayViewport

func set_text(item: Item) -> void:
	weapon_scroller.hide()
	armor_scroller.hide()
	consumable_scroller.hide()
	material_scroller.hide()
	#display_viewport.texture = item.data.sprite
	
	match item.data.item_category:
		ItemData.ITEM_CATEGORY.WEAPON:
			weapon_scroller.set_text(item)
			weapon_scroller.show()
		ItemData.ITEM_CATEGORY.ARMOR:
			#TODO: ARMOR TEXT
			armor_scroller.show()
		ItemData.ITEM_CATEGORY.CONSUMABLE:
			consumable_scroller.set_text(item)
			consumable_scroller.show()
		ItemData.ITEM_CATEGORY.MATERIAL:
			material_scroller.set_text(item)
			material_scroller.show()

class_name InventoryItem extends UIItem

@export var consumable_marker: ColorRect
@export var armor_equipped_marker: ColorRect
@export var mainhand_equipped_marker: ColorRect
@export var offhand_equipped_marker: ColorRect
@export var text_label: Label
@export var sprite: TextureRect
@export var count_label: Label


func _ready() -> void:
	consumable_marker.hide()
	armor_equipped_marker.hide()
	mainhand_equipped_marker.hide()
	offhand_equipped_marker.hide()

func set_equipped_value(equipped_value: int):
	match equipped_value:
		0: return
		1: return
		2: return
		3: return
		4: mainhand_equipped_marker.show()
		5: offhand_equipped_marker.show()
		6: consumable_marker.show()
		7: consumable_marker.show()

func _gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				item_pressed.emit(self, item, "LEFT", slot)
			MOUSE_BUTTON_RIGHT:
				item_pressed.emit(self, item, "RIGHT", slot)

func _on_mouse_entered() -> void:
	modulate = Color(1.164, 1.164, 1.164, 1.0)
	item_hovered.emit(item)

#func _on_pressed() -> void:
	#item_pressed.emit(item)

func set_data(new_item: Item, new_slot: String = "") -> void:
	item = new_item
	text_label.text = item.data.get_combined_name()
	sprite.texture = item.data.sprite
	
	if item.data.stackable:
		count_label.show.call_deferred()
		count_label.text = str(item.data.stack_size)
	else:
		count_label.hide.call_deferred()
		count_label.text = ""
	
	#if item.data.equipped:
		#armor_equipped_marker.show.call_deferred()
	#else:
		#armor_equipped_marker.hide.call_deferred()

	set_slot(new_slot)
	if item.data.equipped == false:
		#consumable_marker.hide()
		armor_equipped_marker.hide()
		mainhand_equipped_marker.hide()
		offhand_equipped_marker.hide()

func set_slot(new_slot: String) -> void:
	slot = new_slot
	if item.data is WeaponData:
		if slot == "MAINHAND":
			mainhand_equipped_marker.show()
			offhand_equipped_marker.hide()
		if slot == "OFFHAND":
			offhand_equipped_marker.show()
			mainhand_equipped_marker.hide()
		if item.data.two_handed:
			offhand_equipped_marker.show()
			mainhand_equipped_marker.show()

func unequip():
	consumable_marker.hide()
	armor_equipped_marker.hide()
	mainhand_equipped_marker.hide()
	offhand_equipped_marker.hide()
	#item.data.equipped = false
	#slot = ""

func mark_consumable():
	consumable_marker.show()

func unmark_consumable():
	consumable_marker.hide()

func _on_mouse_exited() -> void:
	modulate = Color(1,1,1,1)
	item_unhovered.emit()

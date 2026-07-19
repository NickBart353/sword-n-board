extends VBoxContainer

@onready var item_container: VBoxContainer = $ItemContainer

var interface_item_scene = SceneManager.UIItemScenes.get("InterfaceItemHorizontal")

signal close_me

func populate_menu(items: Array) -> void:
	PlayerControls.block_input()
	for item in item_container.get_children():
		item.queue_free()
	
	for item in items:
		var interface_item_instance = interface_item_scene.instantiate()
		item_container.add_child(interface_item_instance)
		interface_item_instance.set_data(item.data)

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_SPACE:
			close_me.emit()
			PlayerControls.call_deferred("unblock_input")

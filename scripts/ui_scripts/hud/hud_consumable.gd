extends TextureRect

@export var count_label: Label

var item: Item

func _ready() -> void:
	count_label.hide()

func set_data(new_item: Item) -> void:
	item = new_item
	count_label.text = item.data.item_name
	texture = item.data.sprite
	if item.data.stackable:
		count_label.show.call_deferred()
		count_label.text = str(item.data.stack_size)
	else:
		count_label.hide.call_deferred()
		count_label.text = ""

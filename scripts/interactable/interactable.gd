class_name Interactable
extends Node3D

@export var hover_text: String

var hovered: bool = false

signal _interact
signal _hover
signal _un_hover

func _ready() -> void:
	$Node3D/SubViewport/Label.text = hover_text
	PlayerControls.interact_key_updated.connect(_update_interact_text)
	update_text("[{0}] {1}".format([PlayerControls.interact_keybind_text, hover_text]))

func _update_interact_text(new_keybind_text: String):
	update_text("[{0}] {1}".format([new_keybind_text, hover_text]))

func interact():
	_interact.emit()

func hover():
	hovered = true
	if not $Text.is_visible():
		$Text.set_visible(true)
	_hover.emit()

func un_hover():
	if hovered:
		$Text.set_visible(false)
		hovered = false
	_un_hover.emit()

func refresh_text(new_text: String):
	hover_text = new_text
	update_text("[{0}] {1}".format([PlayerControls.interact_keybind_text, hover_text]))

func update_text(new_text: String):
	$Node3D/SubViewport/Label.text = new_text

func get_text_visibility():
	return $Text.is_visible()

func set_text_visibility(visibility):
	$Text.set_visible(visibility)

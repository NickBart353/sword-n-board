class_name Item
extends Control

var data: ItemData
var sprite: Texture2D

func _ready() -> void:
	sprite = data.sprite

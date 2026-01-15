extends Control

func open_inventory():
	$PlayerInventory.set_visible(!$PlayerInventory.is_visible())

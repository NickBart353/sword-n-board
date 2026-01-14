class_name Interactable
extends Node3D

signal _interact
signal _hover
signal _un_hover

func interact():
	_interact.emit()

func hover():
	_hover.emit()

func un_hover():
	_un_hover.emit()

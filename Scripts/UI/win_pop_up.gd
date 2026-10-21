extends Control

@export var cont_btn :Button
var parent

func _ready() -> void:
	visible = true
	cont_btn.pressed.connect(show_menu)

func show_menu():
	hide()
	var menu = load("res://Scenes/upgrade_menu.tscn").instantiate()
	add_sibling(menu)
	queue_free()

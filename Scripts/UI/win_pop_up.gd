extends Control

@export var cont_btn :Button
var parent

func _ready() -> void:
	visible = true
	cont_btn.pressed.connect(show_menu)
	cont_btn.grab_focus()
	TextAnimation.slide_in(self, Vector2(0, 2000))

func show_menu():
	var menu = load("res://Scenes/upgrade_menu.tscn").instantiate()
	add_sibling(menu)
	
	queue_free()

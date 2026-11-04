extends Control

@export var cont_btn :Button


var parent

func _ready() -> void:
	visible = true
	cont_btn.pressed.connect(show_menu)
	cont_btn.pressed.connect(UIpressSfx.play)
	cont_btn.grab_focus()
<<<<<<< HEAD
=======
	UIfocusSfx.play()
	TextAnimation.slide_in(self, Vector2(0, 2000))
>>>>>>> 1b7ed48 (added sound effects , and a pause menu)

func show_menu():
	hide()
	var menu = load("res://Scenes/upgrade_menu.tscn").instantiate()
	add_sibling(menu)
	queue_free()

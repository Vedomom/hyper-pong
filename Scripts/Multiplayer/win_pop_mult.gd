extends Control

@export var cont_btn :Button
@export var winner_label : Label
var winner_text

func _ready() -> void:
	visible = true
	cont_btn.pressed.connect(show_menu)
	cont_btn.grab_focus()

func _process(_delta: float) -> void:
	if winner_text:
		winner_label.text = winner_text

func show_menu():
	hide()
	var menu = load("res://Scenes/Multiplayer/upgrade_menu_Multi.tscn").instantiate()
	add_sibling(menu)
	queue_free()

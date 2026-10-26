extends Control


@export var restart_btn : Button
@export var menu_btn : Button
@export var end_text_lbl : Label

var end_text : String

func _ready() -> void:
	visible = false
	restart_btn.pressed.connect(get_tree().reload_current_scene)
	menu_btn.pressed.connect(get_tree().change_scene_to_packed.bind(load("res://Scenes/main_menu.tscn")))

# Called every fra	me. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:


	if end_text:
		end_text_lbl.text = end_text
	if Input.is_action_just_pressed("Left"):
		restart_btn.grab_focus()
	
	elif Input.is_action_just_pressed("Right"):
		menu_btn.grab_focus()

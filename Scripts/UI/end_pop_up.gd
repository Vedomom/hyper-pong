extends Control


@export var restart_btn : Button
@export var menu_btn : Button
@export var end_text_lbl : Label


var end_text : String

func _ready() -> void:
	visible = false
	restart_btn.pressed.connect(get_tree().reload_current_scene)
	menu_btn.pressed.connect(get_tree().change_scene_to_packed.bind(load("res://Scenes/main_menu.tscn")))
<<<<<<< HEAD
=======
	restart_btn.pressed.connect(UIpressSfx.play)
	menu_btn.pressed.connect(UIpressSfx.play)
	TextAnimation.slide_in(self, Vector2(0, 2000))
>>>>>>> 1b7ed48 (added sound effects , and a pause menu)

# Called every fra	me. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:


	if end_text:
		end_text_lbl.text = end_text
	if Input.is_action_just_pressed("Left"):
<<<<<<< HEAD
		restart_btn.grab_focus()
	
	elif Input.is_action_just_pressed("Right"):
		menu_btn.grab_focus()
=======
		restart_btn.call_deferred("grab_focus")
		UIfocusSfx.play()
	
	elif Input.is_action_just_pressed("Right"):
		menu_btn.call_deferred("grab_focus")
		UIfocusSfx.play()
>>>>>>> 1b7ed48 (added sound effects , and a pause menu)

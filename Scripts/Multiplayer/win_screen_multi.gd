extends Control

@export var MM_Btn : Button
@export var NR_Btn : Button
@export var p1_score_label : Label
@export var p2_score_label : Label
@export var winner_label : Label


func _ready() -> void:
	MM_Btn.pressed.connect(get_tree().change_scene_to_file.bind("res://Scenes/main_menu.tscn"))
	NR_Btn.pressed.connect(get_tree().reload_current_scene)
<<<<<<< HEAD
=======
	MM_Btn.pressed.connect(UIpressSfx.play)
	NR_Btn.pressed.connect(UIpressSfx.play)
	TextAnimation.slide_in(self, Vector2(0, 3000), 2.7)
>>>>>>> 1b7ed48 (added sound effects , and a pause menu)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Left"):
		NR_Btn.grab_focus()
		UIfocusSfx.play()
	elif Input.is_action_just_pressed("Right"):
		MM_Btn.grab_focus()
		UIfocusSfx.play()

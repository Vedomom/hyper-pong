extends Control

@export var MM_Btn : Button
@export var NR_Btn : Button

func _ready() -> void:
	MM_Btn.pressed.connect(get_tree().change_scene_to_file.bind("res://Scenes/main_menu.tscn"))
	NR_Btn.pressed.connect(get_tree().reload_current_scene)
	TextAnimation.slide_in(self, Vector2(0, 3000), 2.8)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Left"):
		NR_Btn.call_deferred("grab_focus")
	elif Input.is_action_just_pressed("Right"):
		MM_Btn.call_deferred("grab_focus")

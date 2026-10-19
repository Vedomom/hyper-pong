extends Control

@export var MM_Btn : Button
@export var NR_Btn : Button

func _ready() -> void:
	MM_Btn.pressed.connect(get_tree().change_scene_to_file.bind("res://Scenes/main_menu.tscn"))
	NR_Btn.pressed.connect(get_tree().reload_current_scene)

extends Control

@export var sfx_slider : Slider
@export var music_slider : Slider
@export var back_btn: Button

func _ready() -> void:
	back_btn.pressed.connect(get_tree().change_scene_to_file.bind("res://Scenes/main_menu.tscn"))
	back_btn.pressed.connect(UIpressSfx.play)
	back_btn.focus_entered.connect(UIfocusSfx.play)
	back_btn.grab_focus()

	

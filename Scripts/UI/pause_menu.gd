extends Control

@export var resume_btn : Button
@export var restart_btn : Button
@export var quit_btn : Button
@export var sfx_slider : Slider
@export var music_slider : Slider

func _ready() -> void:
	resume_btn.pressed.connect(resume)
	restart_btn.pressed.connect(get_tree().reload_current_scene)
	quit_btn.pressed.connect(get_tree().change_scene_to_file.bind("res://Scenes/main_menu.tscn"))

	resume_btn.pressed.connect(UIpressSfx.play)
	restart_btn.pressed.connect(UIpressSfx.play)
	quit_btn.pressed.connect(UIpressSfx.play)

	resume_btn.focus_entered.connect(UIfocusSfx.play)
	restart_btn.focus_entered.connect(UIfocusSfx.play)
	quit_btn.focus_entered.connect(UIfocusSfx.play)
	resume_btn.grab_focus()
	hide()
	visibility_changed.connect(resume_btn.grab_focus)
	


func resume():
	get_tree().paused = false
	hide()

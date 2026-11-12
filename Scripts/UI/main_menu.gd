extends Control


@export var play_btn : Button
@export var quit_btn : Button
@export var title_lbl : Label 
@export var mult_btn : Button
@export var setting_btn : Button


var btns : Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = false
	play_btn.pressed.connect(play_game)
	mult_btn.pressed.connect(play_mult_match)
	quit_btn.pressed.connect(get_tree().quit)
	setting_btn.pressed.connect(get_tree().change_scene_to_file.bind("res://Scenes/settings_menu.tscn"))
	play_btn.pressed.connect(UIpressSfx.play)
	mult_btn.pressed.connect(UIpressSfx.play)
	quit_btn.pressed.connect(UIpressSfx.play)
	setting_btn.pressed.connect(UIpressSfx.play)
	play_btn.grab_focus()
	play_btn.focus_entered.connect(UIfocusSfx.play)
	mult_btn.focus_entered.connect(UIfocusSfx.play)
	quit_btn.focus_entered.connect(UIfocusSfx.play)
	setting_btn.focus_entered.connect(UIfocusSfx.play)
	MusicPlayer.stop()


func play_game():
	get_tree().change_scene_to_file("res://Scenes/Court.tscn")

func play_mult_match():
	get_tree().change_scene_to_file("res://Scenes/select_controls.tscn")

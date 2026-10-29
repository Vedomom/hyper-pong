extends Control


@export var play_btn : Button
@export var quit_btn : Button
@export var title_lbl : Label 
@export var mult_btn : Button
var btns : Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = false
	play_btn.pressed.connect(play_game)
	mult_btn.pressed.connect(play_mult_match)
	quit_btn.pressed.connect(get_tree().quit)
	play_btn.grab_focus()



func play_game():
	get_tree().change_scene_to_file("res://Scenes/Court.tscn")

func play_mult_match():
	get_tree().change_scene_to_file("res://Scenes/multiplayer_court.tscn")

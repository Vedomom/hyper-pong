extends Control


@export var play_btn : Button
@export var quit_btn : Button
@export var title_lbl : Label 


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = false
	play_btn.pressed.connect(play_game)

	quit_btn.pressed.connect(get_tree().quit)


func play_game():
	get_tree().change_scene_to_file("res://Scenes/Court.tscn")

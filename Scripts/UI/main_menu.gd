extends Control


@export var play_btn : Button
@export var quit_btn : Button
@export var title_lbl : Label 


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	play_btn.pressed.connect(play_game)

	quit_btn.pressed.connect(get_tree().quit)

func play_game():
	get_tree().change_scene_to_packed(load("res://Scenes/Court.tscn"))

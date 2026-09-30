extends Control


@export var restart_btn : Button
@export var menu_btn : Button
@export var end_text_lbl : Label

var end_text : String

func _ready() -> void:
	visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	restart_btn.pressed.connect(get_tree().reload_current_scene)
	menu_btn.pressed.connect(get_tree().change_scene_to_packed.bind(load("res://Scenes/main_menu.tscn")))

	if end_text:
		end_text_lbl.text = end_text

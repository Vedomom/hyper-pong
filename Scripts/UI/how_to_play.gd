extends Control

@export var quit_btn : Button
@export var scroll_area : ScrollContainer

func _ready() -> void:
	quit_btn.pressed.connect(Transition.change_scene.bind("res://Scenes/main_menu.tscn"))
	quit_btn.pressed.connect(UIpressSfx.play)
	quit_btn.focus_entered.connect(UIfocusSfx.play)

func _process(_delta: float) -> void:
	if Input.is_action_pressed("Down"):
		scroll_area.scroll_vertical += 2
	elif Input.is_action_pressed("Up"):
		scroll_area.scroll_vertical -= 2

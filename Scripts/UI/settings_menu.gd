extends Control

@export var sfx_slider : Slider
@export var music_slider : Slider
@export var back_btn: Button
@export var disp_options: OptionButton
var display_modes
func _ready() -> void:
	back_btn.pressed.connect(Transition.change_scene.bind("res://Scenes/main_menu.tscn"))
	back_btn.pressed.connect(UIpressSfx.play)
	back_btn.focus_entered.connect(UIfocusSfx.play)
	back_btn.grab_focus()
	disp_options.item_selected.connect(change_display_mode)
	disp_options.item_selected.connect(UIpressSfx.play)
	disp_options.focus_entered.connect(UIfocusSfx.play)

	display_modes = {
		"FullScreen" : DisplayServer.WindowMode.WINDOW_MODE_FULLSCREEN
		,"Borderless" : DisplayServer.WindowMode.WINDOW_MODE_MAXIMIZED
		, "Windowed" : DisplayServer.WindowMode.WINDOW_MODE_WINDOWED
	}

	for mode in display_modes:
		disp_options.add_item(mode)

	
func change_display_mode(id):
	print(disp_options.get_item_text(disp_options.selected))
	get_window().mode = display_modes[disp_options.get_item_text(id)]

	if display_modes[disp_options.get_item_text(disp_options.selected)] == DisplayServer.WindowMode.WINDOW_MODE_WINDOWED:
		get_window().borderless = false
	else :
		get_window().borderless = true

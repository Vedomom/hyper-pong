extends Node

func _ready() -> void:
	get_window().content_scale_factor = float(get_window().size.x)/1920.0
	print(get_window().content_scale_factor) 
	get_window().size_changed.connect(_adjust_size)

func _adjust_size():
	get_window().content_scale_factor = float(get_window().size.x)/1920.0

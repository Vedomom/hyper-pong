extends Node

func _ready() -> void:
	get_window().content_scale_factor = float(get_window().size.x)/1920 

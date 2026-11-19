extends AudioStreamPlayer

var initial_volume

func _ready() -> void:
	finished.connect(play)
	initial_volume = volume_linear

func fade_out(duration : float = 0.8):
	var fade_tween = create_tween()

	fade_tween.tween_method(_fade_method, initial_volume ,0.0, duration)
	fade_tween.tween_callback(_pause)

func fade_in(duration : float = 0.8):
	var fade_tween = create_tween()

	if !stream_paused:
		play()
	stream_paused = false
	fade_tween.tween_method(_fade_method, 0.0 ,initial_volume, duration)
	


func _fade_method(value : float):
	volume_linear = value


func _pause():
	stream_paused = true

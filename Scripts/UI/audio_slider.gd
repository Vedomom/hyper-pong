extends HSlider


@export var bus_name : String

var bus_index

func _ready() -> void:
	bus_index = AudioServer.get_bus_index(bus_name)
	value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))
	value_changed.connect(change_volume)
	focus_entered.connect(UIfocusSfx.play)
	

func change_volume(_value:float):
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(_value))
	UIfocusSfx.play()

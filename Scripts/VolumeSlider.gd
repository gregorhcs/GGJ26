class_name BusVolumeSlider extends HSlider

@export var bus_name = "Master"

var bus

func _ready() -> void:
	bus = AudioServer.get_bus_index(bus_name)
	if bus == -1 :
		push_error(bus_name + " is not a bus that exists. Slider will have no effect.")
		return
	value = db_to_linear(AudioServer.get_bus_volume_db(bus))
	print(value)
	min_value = 0.0
	max_value = 1.0
	step = 0.01
	connect("value_changed",set_vol)

func set_vol(val):
	AudioServer.set_bus_volume_db(bus, linear_to_db(val))

extends HSlider


export var bus: String = ""
onready var bus_idx = AudioServer.get_bus_index(bus)


func _ready():
	value = db2linear(AudioServer.get_bus_volume_db(bus_idx))


func _on_VolumeSlider_value_changed(value:float):
	AudioServer.set_bus_volume_db(bus_idx, linear2db(value))

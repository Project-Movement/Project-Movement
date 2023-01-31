extends CanvasLayer

var time = 0  # time in seconds

func _process(delta):
	time += delta

	var minutes = round(time / 60)

	$Time.text = "%02d:%05.2f" % [minutes, time]



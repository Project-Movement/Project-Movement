extends CanvasLayer

var time = 0  # time in seconds
var active = false

func _process(delta):
	if active:
		time += delta

	var minutes = round(time / 60)

	$Time.text = "%02d:%05.2f" % [minutes, time]


func reset():
	print("reset stopwatch")
	time = 0


func stop():
	active = false


func start():
	print("started stopwatch")
	active = true



func _on_StartZone_body_entered(_body:Node):
	reset()
	stop()


func _on_StartZone_body_exited(_body:Node):
	start()

func _on_EndZone_body_entered(_body:Node):
	stop()

extends CanvasLayer

var time = 0  # time in seconds
var active = false

func _process(delta):
	if active:
		time += delta

	# var minutes = round(time / 60)
	var minutes = floor(time / 60)

	# $Time.text = "%02d:%05.2f" % [minutes, time]
	$Time.text = "%02d:%05.2f" % [minutes, fmod(time, 60.0)]
	Globals.time = "%02d:%05.2f" % [minutes, fmod(time, 60.0)]


func reset():
	print("reset stopwatch")
	time = 0


func stop(play_noise:bool = false):
	if active:
		active = false
		if play_noise:
			AudioPlayer.play_ui_sound(AudioPlayer.STOPWATCH_STOP)


func start():
	print("started stopwatch")
	AudioPlayer.play_ui_sound(AudioPlayer.STOPWATCH_START)
	active = true



func _on_StartZone_body_entered(_body:Node):
	if _body.name == "PlayerBody":
		Logger.log_level_action(Logger.ACTIONS.ENTER_START, "")
		reset()
		stop(false)


func _on_StartZone_body_exited(_body:Node):
	if _body.name == "PlayerBody":
		Logger.log_level_action(Logger.ACTIONS.LEAVE_START, "")
		print("exited start zone")
		start()


func _on_EndZone_body_entered(_body:Node):
	if _body.name == "PlayerBody":
		Logger.log_level_action(Logger.ACTIONS.ENTER_END, "")
		# actually level really ends when we quit it?
		# Logger.log_level_end("")
		stop(true)

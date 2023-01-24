extends CanvasLayer


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var vel = get_parent().get_node("PlayerBody").velocity
	var label = $SpeedLabel

	label.text = "X Speed: %.f" % abs(vel.x)


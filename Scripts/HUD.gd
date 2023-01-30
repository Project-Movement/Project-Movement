extends CanvasLayer

onready var xlabel = $XSpeedLabel
onready var ylabel = $YSpeedLabel

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var vel = get_parent().get_node("PlayerBody").velocity

	xlabel.text = "X Speed: %.f" % abs(vel.x)
	ylabel.text = "Y Speed: %.f" % abs(vel.y)


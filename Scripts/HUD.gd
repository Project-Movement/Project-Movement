extends CanvasLayer


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var label = $SpeedLabel
	var healthLabel = $HealthLabel
	var playerHealth = get_parent().get_node("PlayerBody").health
	healthLabel.text = "Health: %.f" % playerHealth
	if playerHealth > 0:
		var vel = get_parent().get_node("PlayerBody").velocity
		label.text = "X Speed: %.f" % abs(vel.x)
	if playerHealth <= 0:
		label.text = "You died, try again."


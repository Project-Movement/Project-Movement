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

	xlabel.text = "X Speed: %.f" % abs(vel.x)
	ylabel.text = "Y Speed: %.f" % (0.0 if player_body.is_on_floor() else abs(vel.y))

	$Dash.text = "Dash: yes" if abilities.is_ability_available("dash") else "Dash: no"
	$Airjump.text = "Airjump: yes" if abilities.is_ability_available("airjump") else "Airjump: no"

extends CanvasLayer

onready var xlabel = $XSpeedLabel
onready var ylabel = $YSpeedLabel
onready var player_body = get_parent().get_node("PlayerBody")
onready var abilities = player_body.get_node("AbilitySystem")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var vel = player_body.velocity

	xlabel.text = "X Speed: %.f" % abs(vel.x)
	ylabel.text = "Y Speed: %.f" % abs(vel.y)

	$Dash.text = "Dash: yes" if abilities.is_ability_available("dash") else "Dash: no"
	$Airjump.text = "Airjump: yes" if abilities.is_ability_available("airjump") else "Airjump: no"

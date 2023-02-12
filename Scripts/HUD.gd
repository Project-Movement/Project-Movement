extends CanvasLayer

onready var xlabel = $SpeedIndicator/XSpeedLabel
onready var ylabel = $SpeedIndicator/YSpeedLabel
onready var dash_indicator = $AbilityIndicator/Dash
onready var airjump_indicator = $AbilityIndicator/Airjump
onready var player_body = get_parent().get_node("PlayerBody")
onready var abilities = player_body.get_node("AbilitySystem")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var vel = player_body.velocity

	xlabel.text = "X Speed: %.f" % abs(vel.x)
	ylabel.text = "Y Speed: %.f" % (0.0 if player_body.is_on_floor() else abs(vel.y))

	var dash_time: float = abilities.get_ability_time_left("dash")
	dash_indicator.text = "Dash: Ready" if abilities.is_ability_available("dash") else "Dash: %.1fs" % dash_time
	airjump_indicator.text = "Airjump: Ready" if abilities.is_ability_available("airjump") else "Airjump: Not Ready"

extends CanvasLayer

onready var xlabel = $SpeedIndicator/XSpeedLabel
onready var ylabel = $SpeedIndicator/YSpeedLabel
onready var dash_indicator = $AbilityIndicator/Dash
onready var superjump_indicator = $AbilityIndicator/SuperJump
onready var player_body = get_parent().get_node("PlayerBody")
onready var abilities = player_body.get_node("AbilitySystem")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var vel = player_body.velocity

	xlabel.text = "X Speed: %.f" % abs(vel.x)
	ylabel.text = "Y Speed: %.f" % (0.0 if player_body.is_on_floor() else abs(vel.y))

	var dash_time: float = abilities.get_ability_time_left("dash")
	var sj_time: float = abilities.get_ability_time_left("superjump")
	dash_indicator.text = "Dash: Ready" if abilities.is_ability_available("dash") else "Dash: %.1fs" % dash_time
	superjump_indicator.text = "Super Jump: Ready" if abilities.is_ability_available("superjump") else "Super Jump: %.1fs" % sj_time

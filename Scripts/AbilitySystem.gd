extends Node2D

var ability_timers = {}



# Called when the node enters the scene tree for the first time.
func _ready():
	ability_timers["dash"] = $DashTimer
	# ability_timers[ABILITIES.AIRJUMP] =
	# ability_timers[ABILITIES.GRAPPLEHOOK] =



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func is_ability_available(ability: String) -> bool:
	return ability_timers[ability].time_left == 0


func use_ability(ability: String) -> bool:
	var was_available = is_ability_available(ability)
	if was_available:
		match ability:
			"dash":
				do_dash()
				ability_timers["dash"].start()

	return was_available


func do_dash():
	var target = get_global_mouse_position()
	var diff = (target - self.global_position).normalized()
	var parent_body = get_parent()
	var dash_magnitude = parent_body.dash_magnitude

	# apply impulse for dash
	parent_body.velocity += diff * dash_magnitude
	# dash minimums - if result after adding isn't as high as base magnitude
	# force it to be the base magnitude
	# so the dash will enfore minimum speed after using it
	if diff.y * parent_body.velocity.y < abs(diff.y * dash_magnitude):
		parent_body.velocity.y = diff.y * dash_magnitude
	if diff.x * parent_body.velocity.x < abs(diff.x * dash_magnitude):
		parent_body.velocity.x = diff.x * dash_magnitude

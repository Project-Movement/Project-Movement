extends Node2D


var max_dashes: int = Globals.max_dashes
var max_airjumps: int = Globals.max_airjumps

var ability_timers = {}
var ability_uses = {}

onready var parent_body = get_parent()


# Called when the node enters the scene tree for the first time.
func _ready():
	ability_timers["dash"] = $DashTimer
	# ability_timers[ABILITIES.AIRJUMP] =
	# ability_timers[ABILITIES.GRAPPLEHOOK] =

	ability_uses["airjump"] = max_airjumps
	ability_uses["dash"] = max_dashes


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	# for checking abilities that are dependent on the world, like double jump
	if parent_body.is_on_floor():
		ability_uses["airjump"] = max_airjumps


func reset_state():
	ability_uses["airjump"] = max_airjumps
	ability_uses["dash"] = max_dashes
	$DashTimer.stop()
	# $DashTimer.time_left = 0


func is_ability_available(ability: String) -> bool:
	# print("tried to use ability " + ability + " with " + str(ability_uses[ability]) + " uses left")
	return ability_uses[ability] > 0


func use_ability(ability: String) -> bool:
	var was_available = is_ability_available(ability)
	if was_available:
		match ability:
			"dash":
				do_dash()
				ability_timers["dash"].start()
			"airjump":
				do_airjump()

	return was_available


func do_dash():
	var target = get_global_mouse_position()
	var diff = (target - self.global_position).normalized()
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

	AudioPlayer.play_sound(AudioPlayer.DASH)

	ability_uses["dash"] -= 1


func do_airjump():
	parent_body.jump()
	ability_uses["airjump"] -= 1


func _on_DashTimer_timeout():
	ability_uses["dash"] = max_dashes

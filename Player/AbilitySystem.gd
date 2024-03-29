extends Node2D


var max_dashes: int = Globals.max_dashes
var max_airjumps: int = Globals.max_airjumps
var max_superjumps: int = Globals.max_superjumps

var ability_timers = {}
var ability_uses = {}

onready var parent_body = get_parent()
onready var dash_ability = $Dash


# Called when the node enters the scene tree for the first time.
func _ready():
	ability_timers["dash"] = $Dash/DashCooldownTimer
	ability_timers["superjump"] = $SuperJumpTimer

	ability_uses["airjump"] = max_airjumps
	ability_uses["dash"] = max_dashes
	ability_uses["superjump"] = max_superjumps


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	# for checking abilities that are dependent on the world, like double jump
	if parent_body.is_on_floor() or parent_body.raycast_is_on_floor():
		ability_uses["airjump"] = max_airjumps


func reset_state():
	ability_uses["airjump"] = max_airjumps
	ability_uses["dash"] = max_dashes
	ability_uses["superjump"] = max_superjumps

	$Dash.o_velocity = Vector2.ZERO
	$Dash.end_dash()

	for timer in ability_timers.values():
		timer.stop()


func is_ability_available(ability: String) -> bool:
	# print("tried to use ability " + ability + " with " + str(ability_uses[ability]) + " uses left")
	match ability:
		"dash":
			return ability_uses[ability] > 0 and not dash_ability.is_dashing()
		_:
			return ability_uses[ability] > 0


func get_ability_time_left(ability: String) -> float:
	return ability_timers[ability].time_left


func use_ability(ability: String) -> bool:
	var was_available = is_ability_available(ability)
	if was_available:
		match ability:
			"dash":
				do_dash()
				ability_timers["dash"].start()
			"airjump":
				do_airjump()
			"superjump":
				do_superjump()
				ability_timers["superjump"].start()
	else:
		Logger.log_level_action(Logger.ACTIONS.ON_COOLDOWN, JSON.print({"ability": ability}))

	return was_available


func do_dash():
	Logger.log_level_action(Logger.ACTIONS.DASH, "")
	var target = get_global_mouse_position()
	var diff = (target - self.global_position).normalized()
	var dash_magnitude = parent_body.dash_magnitude

	# apply impulse for dash
	# var t_velocity = parent_body.velocity + diff * dash_magnitude
	var t_velocity = diff * dash_magnitude
	# var cur_vel_alignment: float = max(0, parent_body.velocity.dot(diff))
	# var cur_vel_in_direction_of_dash: Vector2 = cur_vel_alignment * diff
	# var dash_vel = t_velocity + cur_vel_in_direction_of_dash
	var existing_x = parent_body.velocity.x if parent_body.velocity.x * diff.x > 0 else 0.0
	var existing_y = parent_body.velocity.y if parent_body.velocity.y * diff.y > 0 else 0.0
	# var cur_x = existing_x * diff
	var cur_vel_in_direction_of_dash = Vector2(existing_x, existing_y)

	var dash_vel = t_velocity + cur_vel_in_direction_of_dash
	# enforce dash minimums again?
	if dash_vel.length() < dash_magnitude:
		dash_vel *= (dash_magnitude / dash_vel.length())

	# print(cur_vel_in_direction_of_dash)
	var dash_residue = t_velocity * parent_body.dash_magnitude_leftover
	# var dash_residue = dash_vel * parent_body.dash_magnitude_leftover


	# $Dash.start_dash(parent_body.dash_duration, parent_body.get_node("Sprite"), dash_vel, cur_vel_in_direction_of_dash + dash_residue)
	$Dash.start_dash(parent_body.dash_duration, parent_body.get_node("Sprite"), dash_vel, cur_vel_in_direction_of_dash + dash_residue)

	AudioPlayer.play_sound(AudioPlayer.DASH)

	ability_uses["dash"] -= 1


func do_airjump():
	Logger.log_level_action(Logger.ACTIONS.AIRJUMP, "")
	parent_body.jump()
	ability_uses["airjump"] -= 1

func do_superjump():
	Logger.log_level_action(Logger.ACTIONS.SUPERJUMP, "")
	parent_body.superjump()
	ability_uses["superjump"] -= 1

func _on_DashTimer_timeout():
	AudioPlayer.play_ui_sound(AudioPlayer.DASHRECHARGE)
	ability_uses["dash"] = max_dashes

func _on_SuperJumpTimer_timeout():
	AudioPlayer.play_ui_sound(AudioPlayer.SUPERJUMPRECHARGE)
	ability_uses["superjump"] = max_superjumps

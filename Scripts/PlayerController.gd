extends KinematicBody2D

# yea, this is definitely a real mess right now
# basic player movement kinematics
export var h_accel_ground = 2200  # player's horizontal acceleration
export var h_accel_air = 200
export var max_h_air_influence_speed = 100
export var ground_friction = 1100  # friction of ground
export var exceeding_ground_friction = 3000 # friction of ground when exceeding the max speed
export var max_grounded_speed = 300  # maximum speed on ground
export var gravity = 750  # gravitational acceleration
export var jump_vel = 400  # instantaneous velocity on jump
export var wall_friction = 300  # wall friction
export var max_wallslide_fallingspeed = 400
export var coyote_time_ms = 80  # coyote time, where player can jump despite not being grounded if they were just grounded

# bhopping and walljumping
export var walljump_speed = 350  # x speed after walljump
export var bhop_bonus = 100
export var wallhop_bonus_factor = 0.4
export var jump_buffer_interval = 0.1  # interval to buffer jumps for, in seconds
export var wallslide_leniency_time = 0.2


# abilities
export var dash_magnitude: int = 400  # how much the dash moves

export var glider_y_conversion_efficiency = 0.8  # efficiency of conversion between down and x
export var glider_y_rate = 2.7  # how fast down is converted to horizontal in glider


# other variables
var constant_forces = { "gravity": Vector2(0, gravity) }
var velocity = Vector2()

var last_tick_vel = Vector2()  # save what the engine thinks should be the new velocity after moving and sliding
var last_time_on_floor = 0

var has_jumped_in_buffer_interval = false
var player_is_wallsliding = false  # set to true when player touches a wall, set to false after an interval after player is no longer touching wall
var last_collider_normal_x = 0

var last_direction = 0
var grounded: bool = false

const AbilitySystem = preload("res://Scripts/AbilitySystem.gd")


func _ready():
	PlayerSpawner.player_body = self  # register self with PlayerSpawner

	$JumpTimer.wait_time = jump_buffer_interval
	$JumpTimer.one_shot = true

	$WallJumpLeniencyTimer.wait_time = wallslide_leniency_time
	$WallJumpLeniencyTimer.one_shot = true


func _physics_process(delta):
	player_move(delta)
	last_tick_vel = move_and_slide(velocity, Vector2.UP)


func _input(event):
	if event.is_action("return_title"):
		Logger.log_level_action(Logger.ACTIONS.QUIT_LEVEL, "")
		Logger.log_level_end("")
		var _a = get_tree().change_scene("res://Scenes/TitleScreen.tscn")


func player_move(delta):
	last_direction = Input.get_axis("left", "right")

	# check if player is on wall or was just on wall
	if raycast_is_on_wall():
		player_is_wallsliding = true
		last_collider_normal_x = -1 if $RightWallRay.is_colliding() else 1 if $LeftWallRay.is_colliding() else 0
		$WallJumpLeniencyTimer.stop()
	elif player_is_wallsliding and not raycast_is_on_wall() and $WallJumpLeniencyTimer.is_stopped():
		$WallJumpLeniencyTimer.start()


	grounded = is_on_floor()
	var time = Time.get_ticks_msec()
	if grounded:
		last_time_on_floor = time

	# if we don't bounce, accept the engine's default move and slide velocity change
	# (like if we ran up against a wall we get stopped)
	var bounced = do_any_bounce()

	# landing sound
	# this is getting messy
	if is_on_floor() and not grounded and velocity.y >= jump_vel and not bounced:
		AudioPlayer.play_sound(AudioPlayer.LANDING)

	# if we didn't bounce, accept the default move and slide velocity change
	if not bounced:
		velocity = last_tick_vel

	# handle jump and double jump (midair jump)
	if Input.is_action_just_pressed("jump"):
		has_jumped_in_buffer_interval = true
		$JumpTimer.start()

	# custom way of buffering jumps
	if has_jumped_in_buffer_interval:
		if grounded or ((time - last_time_on_floor) <= coyote_time_ms):
			if not bounced:
				Logger.log_level_action(Logger.ACTIONS.JUMP, "")
				jump()

		elif player_is_wallsliding:  # walljump
			print("walljump" + str(Time.get_ticks_msec()))
			Logger.log_level_action(Logger.ACTIONS.WALLJUMP, "")
			jump()
			velocity.x = walljump_speed if last_collider_normal_x > 0 else -walljump_speed
			player_is_wallsliding = false


	if Input.is_action_just_pressed("airjump") and not grounded:  # try airjump if in air
		$AbilitySystem.use_ability("airjump")


	# grounded character movement
	if grounded and not bounced:
		if Input.is_action_pressed("right"):
			velocity.x += h_accel_ground * delta
			velocity.x = min(velocity.x, 300)
		if Input.is_action_pressed("left"):
			velocity.x -= h_accel_ground * delta
			velocity.x = max(velocity.x, -300)

	else:  # not grounded, in air
		if Input.is_action_pressed("right") and velocity.x < max_h_air_influence_speed:
			velocity.x += h_accel_air * delta
		if Input.is_action_pressed("left") and velocity.x > -max_h_air_influence_speed:
			velocity.x -= h_accel_air * delta

		# elif Input.is_action_pressed("down"):  # can't do both up and down
		# 	# this one only works when falling
		# 	if velocity.y > 0:
		# 		var y_speed_lost = glider_y_rate * velocity.y * delta
		# 		velocity.y -= y_speed_lost
		# 		if velocity.x > 0:
		# 			velocity.x += y_speed_lost * glider_y_conversion_efficiency
		# 		elif velocity.x < 0:
		# 			velocity.x -= y_speed_lost * glider_y_conversion_efficiency
		# 		# TODO: how to handle when player is falling straight down?
		# 		# 		i assume that for animation/sprite purposes we may eventually
		# 		#		have to store the last direction the player character was
		# 		#		facing when they stopped moving, so it could be used here?

	# dash
	if Input.is_action_just_pressed("dash"):
		$AbilitySystem.use_ability("dash")

	# do other movement kinematics calculations
	apply_constant_forces(delta)  # like gravity
	apply_frictions(delta, bounced)  # and friction


func jump():
	velocity.y = -jump_vel
	has_jumped_in_buffer_interval = false
	AudioPlayer.play_sound(AudioPlayer.JUMP)


func do_any_bounce() -> bool:
	var has_bounced = false
	# handle bouncing off walls, jump up, perfect reflection of x vel
	# if player_is_wallsliding:
	# 	if Input.is_action_pressed("jump") and abs(velocity.x) > walljump_speed:
	# 		velocity.x = -velocity.x
	# 		has_bounced = true
	# 	elif has_jumped_in_bhop_interval:
	# 		print("jump was pressed in the last interval, doing a wallhop " + str(Time.get_ticks_msec()))
	# 		# if they time the jump, player goes up instead of just reflecting
	# 		# and keep some horizontal velocity but not all of it, so like
	# 		# a more powerful walljump
	# 		velocity.y = -jump_vel
	# 		if velocity.x > 0:
	# 			velocity.x = -velocity.x * wallhop_bonus_factor - walljump_speed
	# 		elif velocity.x < 0:
	# 			velocity.x = -velocity.x * wallhop_bonus_factor + walljump_speed

	# 		has_bounced = true


	# bouncing off ground, bhopping, perfect preservation of x vel
	# if the player presses jump within the interval in time, they get bonus velocity as well
	if is_on_floor():
		if Input.is_action_pressed("bounce"):
			velocity.y = -jump_vel
			has_bounced = true
			Logger.log_level_action(Logger.ACTIONS.BOUNCE, "")
		if has_jumped_in_buffer_interval:
			velocity.y = -jump_vel
			if velocity.x < 0:
				velocity.x -= bhop_bonus
			elif velocity.x > 0:
				velocity.x += bhop_bonus

			has_bounced = true
			Logger.log_level_action(Logger.ACTIONS.BOUNCE, "")

	return has_bounced


func apply_frictions(delta, bounced):
	if is_on_floor() and not bounced:  # don't slow down if bounced (bhopped)
		# apply grounded friction - force opposite direction of motion
		var friction
		if abs(velocity.x) < max_grounded_speed:
			friction = ground_friction
		elif abs(velocity.x) > max_grounded_speed:
			friction = exceeding_ground_friction
		else:
			friction = 0 if Input.is_action_pressed("left") or Input.is_action_pressed("right") else ground_friction

		if velocity.x > 0:
			velocity.x = max(0, velocity.x + -friction * delta)
		if velocity.x < 0:
			velocity.x = min(0, velocity.x + friction * delta)

	elif player_is_wallsliding and velocity.y > 0:
		# wall sliding, slow down player if falling down wall
		velocity.y -= wall_friction * delta
		velocity.y = min(velocity.y, max_wallslide_fallingspeed)


func apply_constant_forces(delta):
	for val in constant_forces.values():
		velocity += val * delta


func reset_state():
	velocity = Vector2.ZERO
	last_tick_vel = Vector2.ZERO
	$AbilitySystem.reset_state()


# cast a ray to check if the player body is on a wall or not
func raycast_is_on_wall():
	return $LeftWallRay.is_colliding() or $RightWallRay.is_colliding()


func _on_JumpTimer_timeout():
	has_jumped_in_buffer_interval = false


func _on_WallJumpLeniencyTimer_timeout():
	print("no longer on wall")
	player_is_wallsliding = false

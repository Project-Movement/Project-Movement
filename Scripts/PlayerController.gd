extends KinematicBody2D

#export (int) var speed = 200
export var h_accel_ground = 2200  # player's horizontal acceleration
export var h_accel_air = 200
export var max_h_air_influence_speed = 100
export var ground_friction = 1100  # friction of ground
export var exceeding_ground_friction = 3000 # friction of ground when exceeding the max speed
export var max_grounded_speed = 300  # maximum speed on ground
export var gravity = 750  # gravitational acceleration
export var jump_vel = 400  # instantaneous velocity on jump
export var dash_magnitude: int = 400  # how much the dash moves
export var walljump_speed = 350  # x speed after walljump
export var wall_friction = 300  # wall friction
export var coyote_time_ms = 80  # coyote time, where player can jump despite not being grounded if they were just grounded
export var glider_x_conversion_efficiency = 0.8  # efficiency of conversion between x and up
export var glider_y_conversion_efficiency = 0.8  # efficiency of conversion between down and x
export var glider_x_rate = 2  # how fast horizontal is converted to up in glider
export var glider_y_rate = 2.7  # how fast down is converted to horizontal in glider
export var glider_up_antigravity_factor = 0.6  # ratio of gravity that is cancelled when gliding up

var constant_forces = { "gravity": Vector2(0, gravity) }
var velocity = Vector2()
var has_double_jump: bool = true

var last_tick_vel = Vector2()  # save what the engine thinks should be the new velocity after moving and sliding
var last_time_on_floor = 0

func _physics_process(delta):
	player_move(delta)
	last_tick_vel = move_and_slide(velocity, Vector2.UP)


func _input(event):
	# some abilities activations can probably go here later
	pass


func player_move(delta):
	var grounded = is_on_floor()
	var time = Time.get_ticks_msec()
	if grounded:
		last_time_on_floor = time

	# if we don't bounce, accept the engine's default move and slide velocity change
	var bounced = do_any_bounce()
	if not bounced:
		velocity = last_tick_vel

	# handle jump and double jump (midair jump)
	if Input.is_action_just_pressed("jump"):
		# var coyote_activated = false
		# var did_walljump = false
		if grounded:
			velocity.y = -jump_vel
			has_double_jump = true
		elif ((time - last_time_on_floor) <= coyote_time_ms):
			# print("coyote activated")
			# coyote_activated = true
			velocity.y = -jump_vel
			has_double_jump = true
		elif is_on_wall():
			velocity.y = -jump_vel
			var wall_collider = get_last_slide_collision()
			velocity.x = walljump_speed if wall_collider.normal.x > 0 else -walljump_speed
			# did_walljump = true
		elif has_double_jump:  # not grounded by double jump is available
			velocity.y = -jump_vel
			if (Input.is_action_pressed("left") and velocity.x > 0) or (Input.is_action_pressed("right") and velocity.x < 0):
				velocity.x = -velocity.x
			has_double_jump = false


		# if we were grounded or on wall, we didn't use double jump
		# has_double_jump = grounded or coyote_activated or (is_on_wall() and not bounced)


	# grounded character movement
	if grounded and not bounced:
		# has_double_jump = true  # refresh double jump
		if Input.is_action_pressed("right"):
			velocity.x += h_accel_ground * delta
		if Input.is_action_pressed("left"):
			velocity.x -= h_accel_ground * delta

	else:  # not grounded, in air
		if Input.is_action_pressed("right") and velocity.x < max_h_air_influence_speed:
			velocity.x += h_accel_air * delta
		if Input.is_action_pressed("left") and velocity.x > -max_h_air_influence_speed:
			velocity.x -= h_accel_air * delta

		# glider motion - convert horizontal to vertical or vice versa
		if Input.is_action_pressed("up"):
			var x_speed_lost = glider_x_rate * velocity.x * delta
			velocity.y -= abs(x_speed_lost) * glider_x_conversion_efficiency
			velocity.x -= x_speed_lost
			velocity.y -= gravity * delta * glider_up_antigravity_factor  # counter some of gravity

		elif Input.is_action_pressed("down"):  # can't do both up and down
			# this one only works when falling
			if velocity.y > 0:
				var y_speed_lost = glider_y_rate * velocity.y * delta
				velocity.y -= y_speed_lost
				if velocity.x > 0:
					velocity.x += y_speed_lost * glider_y_conversion_efficiency
				elif velocity.x < 0:
					velocity.x -= y_speed_lost * glider_y_conversion_efficiency
				# TODO: how to handle when player is falling straight down?

	# dash
	if Input.is_action_just_pressed("dash"):
		var target = get_global_mouse_position()
		var diff = (target - self.global_position).normalized()

		velocity += diff * dash_magnitude

	# do other movement kinematics calculations
	apply_constant_forces(delta)  # like gravity
	apply_frictions(delta, bounced)  # and friction


func do_any_bounce() -> bool:
	var has_bounced = false
	# handle bouncing off walls, jump up, perfect reflection of x vel
	if is_on_wall() and Input.is_action_pressed("jump") and abs(velocity.x) > walljump_speed:
		velocity.x = -velocity.x
		# velocity.y = -jump_vel
		has_bounced = true

	# bouncing off ground, bhopping, perfect preservation of x vel
	if is_on_floor() and Input.is_action_pressed("jump"):
		velocity.y = -jump_vel
		has_bounced = true
		has_double_jump = true  # TODO evaluate whether it should be ok to refresh double jump after bhop

	return has_bounced


func apply_frictions(delta, bounced):
	if is_on_floor() and not bounced:  # don't slow down if bounced (bhopped)
		# apply grounded friction - force opposite direction of motion
		var friction = ground_friction if abs(velocity.x) <= max_grounded_speed else exceeding_ground_friction
		if velocity.x > 0:
			velocity.x = max(0, velocity.x + -friction * delta)
		if velocity.x < 0:
			velocity.x = min(0, velocity.x + friction * delta)
	elif is_on_wall() and velocity.y > 0:
		# wall sliding, slow down player if falling down wall
		velocity.y -= wall_friction * delta

func apply_constant_forces(delta):
	for val in constant_forces.values():
		velocity += val * delta

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
export var dash_magnitude: int = 400
export var walljump_speed = 350
export var wall_friction = 300

var constant_forces = { "gravity": Vector2(0, gravity) }
var velocity = Vector2()
var has_double_jump: bool = true

var last_tick_vel = Vector2()  # save what the engine thinks should be the new velocity after moving and sliding

func _physics_process(delta):
	player_move(delta)
	last_tick_vel = move_and_slide(velocity, Vector2.UP)


func _input(event):
	# some abilities activations can probably go here later
	pass


func player_move(delta):
	var grounded = is_on_floor()

	# if we don't bounce, accept the engine's default move and slide velocity change
	var bounced = do_any_bounce()
	if not bounced:
		velocity = last_tick_vel

	# handle jump and double jump (midair jump)
	if Input.is_action_just_pressed("jump"):
		if grounded:
			velocity.y = -jump_vel
		elif is_on_wall():
			velocity.y = -jump_vel
			var wall_collider = get_last_slide_collision()
			velocity.x = walljump_speed if wall_collider.normal.x > 0 else -walljump_speed
		elif has_double_jump:  # not grounded by double jump is available
			velocity.y = -jump_vel
			if (Input.is_action_pressed("left") and velocity.x > 0) or (Input.is_action_pressed("right") and velocity.x < 0):
				velocity.x = -velocity.x


		has_double_jump = grounded or is_on_wall()  # if we were grounded or on wall, we didn't use double jump


	# grounded character movement
	if grounded and not bounced:
		has_double_jump = true  # refresh double jump
		if Input.is_action_pressed("right"):
			velocity.x += h_accel_ground * delta
		if Input.is_action_pressed("left"):
			velocity.x -= h_accel_ground * delta

	else:  # not grounded, in air
		if Input.is_action_pressed("right") and velocity.x < max_h_air_influence_speed:
			velocity.x += h_accel_air * delta
		if Input.is_action_pressed("left") and velocity.x > -max_h_air_influence_speed:
			velocity.x -= h_accel_air * delta

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

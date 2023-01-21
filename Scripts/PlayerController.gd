extends KinematicBody2D

#export (int) var speed = 200
export var h_accel_ground = 2200  # player's horizontal acceleration
export var h_accel_air = 200
export var max_h_air_influence_speed = 100
export var ground_friction = 1100  # friction of ground
export var max_grounded_speed = 300  # maximum speed on ground
export var gravity = 750  # gravitational acceleration
export var jump_vel = 400  # instantaneous velocity on jump
export var dash_magnitude: int = 400

var constant_forces = { "gravity": Vector2(0, gravity) }
var velocity = Vector2()
var has_double_jump: bool = true

var last_tick_vel = Vector2()  # save what the engine thinks should be the new velocity after moving and sliding

func _physics_process(delta):
	player_move(delta)
	apply_constant_forces(delta)
	last_tick_vel = move_and_slide(velocity, Vector2.UP)


func _input(event):
	# some abilities activations can probably go here later
	pass


func player_move(delta):
	var grounded = is_on_floor()

	# if we don't bounce, accept the engine's default move and slide velocity change
	if not do_any_bounce():
		velocity = last_tick_vel

	# handle jump and double jump (midair jump)
	if Input.is_action_just_pressed("jump"):
		if grounded or has_double_jump:
			velocity.y = -jump_vel

		has_double_jump = false if not grounded else true


	# apply grounded kinematics
	if grounded:
		has_double_jump = true  # refresh double jump
		if Input.is_action_pressed("right"):
			velocity.x += h_accel_ground * delta
		if Input.is_action_pressed("left"):
			velocity.x -= h_accel_ground * delta

		# apply grounded friction - force opposite direction of motion
		if velocity.x > 0:
			velocity.x = max(0, velocity.x + -ground_friction * delta)
			velocity.x = min(max_grounded_speed, velocity.x)
		if velocity.x < 0:
			velocity.x = min(0, velocity.x + ground_friction * delta)
			velocity.x = max(-max_grounded_speed, velocity.x)
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


func do_any_bounce() -> bool:
	var has_bounced = false
	# handle bouncing off walls
	if is_on_wall() and Input.is_action_pressed("jump"):
		velocity.x = -velocity.x
		has_bounced = true

	return has_bounced



func apply_constant_forces(delta):
	for val in constant_forces.values():
		velocity += val * delta

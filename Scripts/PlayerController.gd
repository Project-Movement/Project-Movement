extends KinematicBody2D

# yea, this is definitely a real mess right now
# basic player movement kinematics
export var h_accel_ground = 0.1  # horizontal ground acceleration, in lerp weight
export var h_accel_air = 200  #  horizontal air accelration
export var max_h_air_influence_speed = 350  # maximum speed in air
export var max_grounded_speed = 300  # maximum speed on ground
export var gravity = 750  # gravitational acceleration
export var jump_vel = 400  # instantaneous velocity on jump
export var ground_friction = 0.5  # wall friction, in lerp weight
export var wall_friction = 300  # wall friction
export var coyote_time_ms = 80  # coyote time, where player can jump despite not being grounded if they were just grounded

# bhopping and walljumping
export var walljump_speed = 350  # x speed after wall hop
export var bhop_bonus = 100
export var wallhop_bonus_factor = 0.4
export var bhop_interval = 0.1  # interval to be able to do a bhop, in seconds
export var whop_interval = 0.1  # interval to be able to do a whop, in seconds

# abilities
export var dash_magnitude: int = 400  # how much the dash moves

export var glider_y_conversion_efficiency = 0.8  # efficiency of conversion between down and x
export var glider_y_rate = 2.7  # how fast down is converted to horizontal in glider


# other variables
var constant_forces = { "gravity": Vector2(0, gravity) }
var velocity = Vector2()

var last_tick_vel = Vector2()  # save what the engine thinks should be the new velocity after moving and sliding
var last_time_on_floor = 0
var was_in_air = false
var last_recorded_max_x = []

var bhop_interval_open = false
var whop_interval_open = false

const AbilitySystem = preload("res://Scripts/AbilitySystem.gd")


func _ready():
	$JumpTimer.wait_time = bhop_interval
	$JumpTimer.one_shot = true
	$WallTimer.wait_time = whop_interval
	$WallTimer.one_shot = true
	last_recorded_max_x.resize(30)


func _physics_process(delta):
	player_move(delta)
	last_tick_vel = move_and_slide(velocity, Vector2.UP)


func _input(event):
	if event.is_action("return_title"):
		var _a = get_tree().change_scene("res://Scenes/TitleScreen.tscn")


func player_move(delta):
	var grounded = is_on_floor()
	var time = Time.get_ticks_msec()

	last_recorded_max_x.pop_back()
	last_recorded_max_x.push_front(velocity.x)

	if grounded:
		last_time_on_floor = time
	
	if was_in_air and grounded:
		bhop_interval_open = true
		$JumpTimer.start()
		print("bhop open")
	if was_in_air and is_on_wall():
		whop_interval_open = true
		$WallTimer.start()
		print("wjump open")
		
	was_in_air = false if is_on_wall() or grounded else true

	# if we don't bounce, accept the engine's default move and slide velocity change
	# (like if we ran up against a wall we get stopped)
	var bounced = do_any_bounce()
	if not bounced:
		velocity = last_tick_vel

	# handle jump and double jump (midair jump)
	if Input.is_action_pressed("jump"):
		if grounded or ((time - last_time_on_floor) <= coyote_time_ms):
			velocity.y = -jump_vel

		elif is_on_wall() and not bounced:  # walljump
			velocity.y = -jump_vel
			var wall_collider = get_last_slide_collision()
			velocity.x = walljump_speed if wall_collider.normal.x > 0 else -walljump_speed

	if  Input.is_action_just_pressed("jump") and not (grounded or is_on_wall()):  # try airjump if in air
		$AbilitySystem.use_ability("airjump")

	var dir = Input.get_axis("left", "right")
	if dir != 0:
		if grounded:
			velocity.x = lerp(velocity.x, dir * max_grounded_speed, 0.1)
		else:  # not grounded, in air
			if abs(velocity.x) < max_h_air_influence_speed:
				velocity.x += h_accel_air * dir * delta
	else:  # dir == 0
		if grounded:
			velocity.x = lerp(velocity.x, 0.0, 0.5)

	# dash
	if Input.is_action_just_pressed("dash"):
		$AbilitySystem.use_ability("dash")

	# do other movement kinematics calculations
	apply_constant_forces(delta)  # like gravity


func do_any_bounce() -> bool:
	var has_bounced = false
	# handle bouncing off walls, jump up, perfect reflection of x vel
	if is_on_wall():
		if whop_interval_open and Input.is_action_just_pressed("jump"):
			print("jump was pressed in the last interval, doing a wallhop " + str(Time.get_ticks_msec()))
			# if they time the jump, player goes up instead of just reflecting
			# and keep some horizontal velocity but not all of it, so like
			# a more powerful walljump
			velocity.y = -jump_vel
			var prev_vel = last_recorded_max_x.max() if last_recorded_max_x.back() > 0 else last_recorded_max_x.min()
			print (str(prev_vel))
			print (str(velocity.x))
			if velocity.x > 0:
				velocity.x = -prev_vel * wallhop_bonus_factor - walljump_speed
			elif velocity.x < 0:
				velocity.x = -prev_vel * wallhop_bonus_factor + walljump_speed

			has_bounced = true


	# bouncing off ground, bhopping, perfect preservation of x vel
	# if the player presses jump within the interval in time, they get bonus velocity as well
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			velocity.y = -jump_vel
			has_bounced = true
			if bhop_interval_open:
				print("bhop!")
				if velocity.x < 0:
					velocity.x -= bhop_bonus
				elif velocity.x > 0:
					velocity.x += bhop_bonus

			has_bounced = true
	return has_bounced

func apply_constant_forces(delta):
	for val in constant_forces.values():
		velocity += val * delta
	if is_on_wall() and velocity.y > 0:
		# wall sliding, slow down player if falling down wall
		velocity.y -= wall_friction * delta


func reset_state():
	velocity = Vector2.ZERO
	last_tick_vel = Vector2.ZERO
	$AbilitySystem.reset_state()

func _on_JumpTimer_timeout():
	bhop_interval_open = false
	print("bhop closed")

func _on_WallTimer_timeout():
	whop_interval_open = false
	print("wjump closed")


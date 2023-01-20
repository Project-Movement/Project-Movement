extends KinematicBody2D

#export (int) var speed = 200
export var h_accel = 2000
export var ground_friction = 900
export var max_grounded_speed = 300
export var gravity = 750
export var jump_vel = 400

var constant_forces = { "gravity": Vector2(0, gravity) }
var velocity = Vector2()
var has_double_jump: bool = true
#var last_jump_time: int = Time.get_ticks_msec()
#var jump_deadtime: int = 200


func player_move(delta):
	var direction = velocity.normalized()
	var grounded = is_on_floor()
	if grounded:
		has_double_jump = true
		if Input.is_action_pressed("right"):
			velocity.x += h_accel * delta
		if Input.is_action_pressed("left"):
			velocity.x -= h_accel * delta

		# apply grounded friction - force opposite direction of motion
		if velocity.x > 0:
			velocity.x = max(0, velocity.x + -ground_friction * delta)
			velocity.x = min(max_grounded_speed, velocity.x)
		if velocity.x < 0:
			velocity.x = min(0, velocity.x + ground_friction * delta)
			velocity.x = max(-max_grounded_speed, velocity.x)

#	if Input.is_action_pressed("jump") and Time.get_ticks_msec() - last_jump_time > jump_deadtime:
	if Input.is_action_just_pressed("jump"):
#		print("jump press")
		print("has double jump: " + str(has_double_jump))
		if grounded or has_double_jump:
			velocity.y = -jump_vel
		
		has_double_jump = false if not grounded else true


func apply_constant_forces(delta):
	for val in constant_forces.values():
		velocity += val * delta
	

func _physics_process(delta):
	apply_constant_forces(delta)
	player_move(delta)
	velocity = move_and_slide(velocity, Vector2.UP)

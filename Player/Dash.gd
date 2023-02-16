extends Node2D


onready var duration_timer: = $DashDurationTimer
onready var ghost_timer: = $DashGhostTimer
onready var parent_body: = get_parent().get_parent()
onready var ability_system: = get_parent()

# var ghost_scene = preload("res://DashGhost.tscn")
# var can_dash = true
var sprite
var o_velocity


func start_dash(duration: float, sprite: Sprite, velocity: Vector2, o_velocity):
	duration_timer.wait_time = duration
	duration_timer.start()

	self.sprite = sprite
	# sprite.material.set_shader_param("mix_weight", 0.7)
	# sprite.material.set_shader_param("whiten", true)

	ghost_timer.start()
	instance_ghost()

	self.o_velocity = o_velocity
	parent_body.set_controls_enabled(false)
	parent_body.set_constant_forces_enabled(false)
	parent_body.set_friction_enabled(false)
	parent_body.velocity = velocity


func instance_ghost():
	# var ghost: Sprite = ghost_scene.instance()
	# parent_body.get_parent().add_child(ghost)

	# ghost.global_position = global_position
	# ghost.texture = sprite.texture
	# ghost.vframes = sprite.vframes
	# ghost.hframes = sprite.hframes
	# ghost.frame = sprite.frame
	# ghost.flip_h = sprite.flip_h
	pass


func is_dashing():
	return !duration_timer.is_stopped()


func end_dash():
	# sprite.material.set_shader_param("whiten", false)
	ghost_timer.stop()
	parent_body.set_controls_enabled(true)
	parent_body.set_constant_forces_enabled(true)
	parent_body.set_friction_enabled(true)
	parent_body.override_velocity(o_velocity)
	# ability_system.ability_timers["dash"].start()


func _on_DashDurationTimer_timeout() -> void:
	end_dash()


func _on_DashGhostTimer_timeout() -> void:
	instance_ghost()

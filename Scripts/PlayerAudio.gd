extends Node2D


onready var player_body: = get_parent()
onready var step_timer: = $StepTimer

export var min_step_interval = 0.15

const base_step_interval = 0.3
const step_factor = 260
var step_interval = 0.8

func _physics_process(_delta):

	# AudioPlayer.play_sound(AudioPlayer.STEP)
	if player_body.is_on_floor() and abs(player_body.velocity.x) > 20:
		step_interval = (base_step_interval / abs(player_body.velocity.x)) * step_factor
		step_interval = max(min_step_interval, step_interval)
		# print("step_interval " + str(step_interval))
		if step_timer.is_stopped() or step_timer.time_left > step_interval:
			# print("jgao222 + starting timer")
			# step_timer.stop()
			step_timer.start(step_interval)

	else:
		step_timer.stop()


func _on_StepTimer_timeout():
	AudioPlayer.play_sound(AudioPlayer.STEP)


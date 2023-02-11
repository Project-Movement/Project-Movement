extends Node2D


onready var player_body: = get_parent()
onready var step_timer: = $StepTimer

export var min_step_interval = 210

const base_step_interval = 100
const step_factor = 500
var step_interval

onready var time_of_last_step = Time.get_ticks_msec()

func _physics_process(_delta):
	if player_body.is_on_floor() and abs(player_body.velocity.x) > 0 and not player_body.is_on_wall():
		step_interval = (base_step_interval / abs(player_body.velocity.x)) * step_factor
		step_interval = max(min_step_interval, step_interval)

		if Time.get_ticks_msec() - time_of_last_step >= step_interval:
			play_step_sound()
			time_of_last_step = Time.get_ticks_msec()


func play_step_sound():
	AudioPlayer.play_sound(AudioPlayer.STEP)
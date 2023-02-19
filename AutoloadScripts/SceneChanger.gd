extends Node

var cur_level = -1


## Handles changing to a level scene, setting cur_level to one of the consts in
## Levels.gd
func change_to_level(level: int):
	if not level in Levels.level_to_filename:
		printerr("Called to switch to nonexistent scene: " + str(level))
		return

	Logger.log_level_start(level, str(Time.get_ticks_msec()))
	cur_level = level
	# TODO changing scene can err, might need to be handled
	var _a = get_tree().change_scene(Levels.get_scene_name(level));
	disable_audio_1tick()

## Handles changing to a non-level scene, automatically logging level end
## if we were in a level
func change_to_nonlevel(scene: String):
	if cur_level != -1:
		Logger.log_level_end(str(Time.get_ticks_msec()))
		cur_level = -1

	# TODO changing scene can err, might need to be handled
	var _a = get_tree().change_scene(scene);
	disable_audio_1tick()


func disable_audio_1tick():
	AudioPlayer.enabled = false
	yield(get_tree().create_timer(0), "timeout")
	AudioPlayer.enabled = true

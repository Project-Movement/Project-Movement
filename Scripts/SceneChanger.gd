extends Node

var cur_level = -1


func change_to_level(level: int):
	if not level in Levels.level_to_filename:
		printerr("Called to switch to nonexistent scene: " + str(level))
		return

	Logger.log_level_start(level, str(Time.get_ticks_msec()))
	cur_level = level
	# TODO changing scene can err, might need to be handled
	var _a = get_tree().change_scene(Levels.get_scene_name(level));


func change_to_nonlevel(scene: String):
	if cur_level != -1:
		Logger.log_level_end(str(Time.get_ticks_msec()))
		cur_level = -1

	# TODO changing scene can err, might need to be handled
	var _a = get_tree().change_scene(scene);

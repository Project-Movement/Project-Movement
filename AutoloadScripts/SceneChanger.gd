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

	if _a == ERR_CANT_OPEN:
		printerr("scene changing failed: couldn't open scene")
	elif _a == ERR_CANT_CREATE:
		printerr("scene changing failed: couldn't create scene")

## Handles changing to a non-level scene, automatically logging level end
## if we were in a level
func change_to_nonlevel(scene: String):
	if cur_level != -1:
		Logger.log_level_end(str(Time.get_ticks_msec()))
		cur_level = -1
	print("changing to " + scene)

	# TODO changing scene can err, might need to be handled
	var _a = get_tree().change_scene(scene);
	disable_audio_1tick()


func change_to_next_level():
	if cur_level_index == -1:
		printerr("can't change to next level since there is no current level")
		return
	if not has_next_level():
		printerr("there is no next level to change to")
		return

	cur_level_index += 1
	change_to_level(Levels.levels_list[cur_level_index])


func has_next_level():
	return cur_level_index + 1 < Levels.levels_list.size()


	if _a == ERR_CANT_OPEN:
		printerr("scene changing failed: couldn't open scene")
	elif _a == ERR_CANT_CREATE:
		printerr("scene changing failed: couldn't create scene")
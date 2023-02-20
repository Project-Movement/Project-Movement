extends Button

## A button which will upon press change the level. If the scene is a level
## you should use the level's name from Levels.gd, otherwise the path to it.
export var scene_name: String = ""
export var is_level: bool = true  # IMPORTANT! set this boolean depending on if the text will change to level or not


func _on_LevelButton_pressed():
	if scene_name == "":
		printerr("button pressed with no scene name " + str(self))
		return
	# print(scene_name)
	if is_level:
		if not scene_name in Levels:
			printerr("level '" + scene_name + "' doesn't exist in Levels enum")
			return
		print("changing to '" + scene_name + "' which is level " + str(Levels[scene_name]))
		SceneChanger.change_to_level(Levels[scene_name])
	else:
		print("changing to '" + scene_name + "'")
		SceneChanger.change_to_nonlevel(scene_name)

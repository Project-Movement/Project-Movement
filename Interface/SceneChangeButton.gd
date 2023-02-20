extends DefaultButton
# class_name SceneChangeButton

## A button which will upon press change the level. If the scene is a level
## you should use the level's name from Levels.gd, otherwise the path to it.

### name of scene enum variant in Levels.gd, or path to non-level scene
export var scene_name: String = ""
### if the scene this button should take you to is a level or not
export var is_level: bool = true  # IMPORTANT! set this boolean depending on if the text will change to level or not


func _on_SceneChangeButton_pressed():
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

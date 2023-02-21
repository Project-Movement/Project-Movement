extends Control

export (String, FILE) var main_scene

# Called when the node enters the scene tree for the first time.
func _ready():
	if Globals.LOGGING_ENABLED:
		yield(Logger.start_new_session(), "completed")
	SceneChanger.change_to_nonlevel(main_scene)

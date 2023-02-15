extends Node2D



func go_tutorial():
	SceneChanger.change_to_level(Levels.TUTORIAL_BASIC)

func go_tutorial2():
	SceneChanger.change_to_level(Levels.TUTORIAL_ADVANCED2)

func go_dearYouWallJump():
	SceneChanger.change_to_level(Levels.DEARYOU_WALLJUMP)

func go_circus():
	SceneChanger.change_to_level(Levels.CIRCUS)

func go_level3():
	SceneChanger.change_to_level(Levels.LEVEL1)

func quit():
	get_tree().notification(MainLoop.NOTIFICATION_WM_QUIT_REQUEST)


func _on_DevSettings_pressed():
	Logger.log_action_with_no_level(Logger.ACTIONS.ENTER_DEV_SETTINGS, "")
	SceneChanger.change_to_nonlevel("res://Interface/DevSettings.tscn")


func _on_TutorialAdvance_pressed():
	pass # Replace with function body.

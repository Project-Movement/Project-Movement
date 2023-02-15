extends Node2D



func go_tutorial():
	# var _a = get_tree().change_scene("res://Scenes/Tutorial.tscn")
	SceneChanger.change_to_level(Levels.TUTORIAL_BASIC)

func go_tutorial2():
	# var _a = get_tree().change_scene("res://Scenes/AdvancedTutorial2.tscn")
	SceneChanger.change_to_level(Levels.TUTORIAL_ADVANCED2)

func go_dearYouWallJump():
	# var _a = get_tree().change_scene("res://Scenes/DearYouWallJump.tscn")
	SceneChanger.change_to_level(Levels.DEARYOU_WALLJUMP)

func go_circus():
	# var _a = get_tree().change_scene("res://Scenes/Circus.tscn")
	SceneChanger.change_to_level(Levels.CIRCUS)

func go_level3():
	# var _a = get_tree().change_scene("res://Scenes/Level1.tscn")
	SceneChanger.change_to_level(Levels.LEVEL1)

func quit():
	get_tree().notification(MainLoop.NOTIFICATION_WM_QUIT_REQUEST)


func _on_DevSettings_pressed():
	Logger.log_action_with_no_level(Logger.ACTIONS.ENTER_DEV_SETTINGS, "")
	# var _a = get_tree().change_scene("res://Scenes/DevSettings.tscn")
	SceneChanger.change_to_nonlevel("res://Scenes/DevSettings.tscn")


func _on_TutorialAdvance_pressed():
	pass # Replace with function body.

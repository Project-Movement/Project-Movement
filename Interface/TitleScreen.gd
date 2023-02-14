extends Node2D



func go_tutorial():
	var _a = get_tree().change_scene("res://Scenes/Tutorial.tscn")

func go_tutorial2():
	var _a = get_tree().change_scene("res://Scenes/AdvancedTutorial2.tscn")

func go_dearYouWallJump():
	var _a = get_tree().change_scene("res://Scenes/DearYouWallJump.tscn")

func go_circus():
	var _a = get_tree().change_scene("res://Scenes/Circus.tscn")

func go_level3():
	var _a = get_tree().change_scene("res://Scenes/Level1.tscn")

func quit():
	get_tree().notification(MainLoop.NOTIFICATION_WM_QUIT_REQUEST)


func _on_DevSettings_pressed():
	Logger.log_action_with_no_level(Logger.ACTIONS.ENTER_DEV_SETTINGS, "")
	var _a = get_tree().change_scene("res://Scenes/DevSettings.tscn")


func _on_TutorialAdvance_pressed():
	pass # Replace with function body.
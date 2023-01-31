extends Node2D



func go_tutorial():
	var _a = get_tree().change_scene("res://Scenes/TutorialLevel.tscn")


func go_level1():
	var _a = get_tree().change_scene("res://Scenes/FirstLevel.tscn")


func go_testlevel():
	var _a = get_tree().change_scene("res://Scenes/TestLevel.tscn")


func quit():
	get_tree().quit()

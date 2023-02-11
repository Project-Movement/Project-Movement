extends Node2D



func go_tutorial():
	Globals.current_level = ("res://Scenes/Tutorial.tscn")
	var _a = get_tree().change_scene("res://Scenes/Tutorial.tscn")

func go_level1():
	Globals.current_level = ("res://Scenes/AdvancedTutorial.tscn")
	var _a = get_tree().change_scene("res://Scenes/AdvancedTutorial.tscn")

func go_testlevel():
	Globals.current_level =  ("res://Scenes/Level1.tscn")
	var _a = get_tree().change_scene("res://Scenes/Level1.tscn")

func quit():
	get_tree().quit()

func _on_DevSettings_pressed():
	var _a = get_tree().change_scene("res://Scenes/DevSettings.tscn")
	

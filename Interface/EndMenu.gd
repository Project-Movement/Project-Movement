extends Node2D

func _process(_delta):
	get_node("ColorRect/CenterContainer/VBoxContainer/EndTime").text = "Time: " + Globals.time


func _on_Retry_pressed():
	SceneChanger.change_to_level(SceneChanger.prev_level)


func _on_Next_level_pressed():
	SceneChanger.change_to_level(SceneChanger.prev_level+1)


func _on_Level_Menu_pressed():
	SceneChanger.change_to_nonlevel("res://Interface/TitleScreen.tscn")

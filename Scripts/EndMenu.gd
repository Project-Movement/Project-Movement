extends Node2D

func _process(delta):
	get_node("CenterContainer/VBoxContainer/EndTime").text = "Time: " + Globals.time

func _on_Retry_pressed():
	var _a = get_tree().change_scene(Globals.current_level)

func _on_Main_Menu_pressed():
	var _a = get_tree().change_scene("res://Scenes/TitleScreen.tscn")
	


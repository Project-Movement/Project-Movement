extends Control


func _process(delta):
	if Globals.level_completed == true:
		visible = true
		get_tree().paused = true	
	get_node("ColorRect/CenterContainer/VBoxContainer/EndTime").text = "Time: " + Globals.time


func _on_Retry_pressed():
	self.set_state()
	get_tree().reload_current_scene()


func _on_Next_level_pressed():
	self.set_state()
	SceneChanger.change_to_level(Levels.CIRCUS)


func _on_Level_Menu_pressed():
	self.set_state()
	SceneChanger.change_to_nonlevel("res://Interface/TitleScreen.tscn")
	
func set_state():
	Globals.level_completed = false
	visible = false
	get_tree().paused = false

extends Control

func _unhandled_input(event):
	if event.is_action_pressed("return_title") and not Globals.level_completed and not self.visible:
		self.visible = true
		$"../../PlayerBody".set_controls_enabled(false)
		get_tree().paused = true
	elif event.is_action_pressed("return_title") and self.visible:
		self.set_state()	
		
#func _input(event):
#	if event.is_action_pressed("return_title") and self.visible:
#		self.set_state()
#
func _on_Resume_pressed():
	self.set_state()
	
func _on_Retry_pressed():
	self.set_state()
	var _a = get_tree().reload_current_scene()
	
func _on_Menu_pressed():
	self.set_state()
	SceneChanger.change_to_nonlevel("res://Interface/TitleScreen.tscn")
	Logger.log_level_action(Logger.ACTIONS.QUIT_LEVEL, "")
	
func set_state():
	get_tree().paused = false
	$"../../PlayerBody".set_controls_enabled(true)
	self.visible = false
	



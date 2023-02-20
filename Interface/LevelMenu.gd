extends Control

onready var next_level_button: = $"ColorRect/CenterContainer/VBoxContainer/Next level"


func _process(_delta):
	if Globals.level_completed == true and not self.visible:
		visible = true
		# get_tree().paused = true
		$"../../PlayerBody".set_controls_enabled(false)
		get_node("ColorRect/CenterContainer/VBoxContainer/EndTime").text = "Time: " + Globals.time
		if not SceneChanger.has_next_level():
			next_level_button.visible = false


func _on_Retry_pressed():
	self.set_state()
	var _a = get_tree().reload_current_scene()


func _on_Next_level_pressed():
	if SceneChanger.has_next_level():
		self.set_state()
		# SceneChanger.change_to_level(Levels.CIRCUS)
		SceneChanger.change_to_next_level()


func _on_Level_Menu_pressed():
	self.set_state()
	SceneChanger.change_to_nonlevel("res://Interface/TitleScreen.tscn")

func set_state():
	Globals.level_completed = false
	visible = false
	get_tree().paused = false

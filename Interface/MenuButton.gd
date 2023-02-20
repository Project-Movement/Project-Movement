extends Button


func _on_MenuButton_button_down():
	# AudioPlayer.play_ui_sound(AudioPlayer.DROP3)
	pass


func _on_MenuButton_button_up():
	# AudioPlayer.play_ui_sound(AudioPlayer.DROP4)
	pass


func _on_MenuButton_pressed():
	AudioPlayer.play_ui_sound(AudioPlayer.DROP4)


func _on_MenuButton_mouse_entered():
	AudioPlayer.play_ui_sound(AudioPlayer.CLICK2)



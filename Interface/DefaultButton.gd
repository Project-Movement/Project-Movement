extends Button
class_name DefaultButton


func _on_DefaultButton_button_down():
	# AudioPlayer.play_ui_sound(AudioPlayer.DROP3)
	pass


func _on_DefaultButton_button_up():
	# AudioPlayer.play_ui_sound(AudioPlayer.DROP4)
	pass


func _on_DefaultButton_pressed():
	AudioPlayer.play_ui_sound(AudioPlayer.DROP4)


func _on_DefaultButton_mouse_entered():
	AudioPlayer.play_ui_sound(AudioPlayer.CLICK2)



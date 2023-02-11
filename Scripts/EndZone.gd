extends Area2D


func _on_EndZone_body_entered(body):
	if body.name == "PlayerBody":
		var _a = get_tree().change_scene("res://Scenes/EndMenu.tscn")
		

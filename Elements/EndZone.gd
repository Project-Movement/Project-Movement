extends Area2D


func _on_EndZone_body_entered(body):
	if body.name == "PlayerBody":
		Globals.level_completed = true
		

extends Area2D


func _on_KillZone_body_entered(_body:Node):
	if _body.name == "PlayerBody":
		PlayerSpawner.respawn_player()

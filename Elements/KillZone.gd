extends Area2D


func _on_KillZone_body_entered(_body:Node):
	if _body.name == "PlayerBody":
		AudioPlayer.play_sound(AudioPlayer.DIE)
		Logger.log_level_action(Logger.ACTIONS.PLAYER_DIE, str((_body as KinematicBody2D).global_position))
		# yield(get_tree().create_timer(0.3), "timeout")
		PlayerSpawner.respawn_player()

extends Node

export var spawn_position = Vector2()

var player_body


func _input(event):
	if event.is_action_pressed("restart") and player_body.controls_enabled:
		respawn_player()


func respawn_player():
	player_body.global_position = spawn_position
	player_body.reset_state()


func set_spawn_position(point: Vector2):
	print("set spawn")
	spawn_position = point

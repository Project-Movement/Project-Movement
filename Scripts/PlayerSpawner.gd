extends Node2D

export var spawn_position = Vector2()

onready var player_body = $"../Player/PlayerBody"


func _input(event):
	if event.is_action_pressed("restart"):
		respawn_player()


func respawn_player():
	player_body.global_position = spawn_position
	player_body.reset_state()


func set_spawn_position(point: Vector2):
	spawn_position = point


func _on_KillZone_body_entered(_body:Node):
	respawn_player()

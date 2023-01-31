extends Area2D
export var damage = 5
var playerInArea: Player = null

func _process(delta):
	if playerInArea != null:
		playerInArea.damage_taken(damage)

func _on_Enemy_attack_zone_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body is Player:
		playerInArea = body
		playerInArea.damage_taken(damage)


func _on_Enemy_attack_zone_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	if body is Player:
		playerInArea = null

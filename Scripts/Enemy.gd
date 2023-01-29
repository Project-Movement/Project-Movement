extends Area2D
class_name Enemy

export var damage = 5
export var health = 10
var playerInArea: Player = null

func _process(delta):
	if playerInArea != null:
		playerInArea.damage_taken(damage)

func _physics_process(delta):
	pass
	
func damage_taken(amount:int):
	health-=amount
	if health <= 0:
		queue_free()

func _on_Enemy_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body is Player:
		playerInArea = body
		body.damage_taken(damage)


func _on_Enemy_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	if body is Player:
		playerInArea = null

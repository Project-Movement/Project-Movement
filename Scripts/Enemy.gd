extends Area2D
class_name Enemy

export var damage = 5
export var health = 10

func _physics_process(delta):
	pass
	
func damage_taken(amount:int):
	health-=amount
	if health <= 0:
		queue_free()

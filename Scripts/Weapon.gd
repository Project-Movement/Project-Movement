extends Area2D
class_name Weapon

export var damage: int = 10



func _on_Weapon_area_entered(area):
	if area .is_in_group("Damageable"):
		area.damage_taken(damage)

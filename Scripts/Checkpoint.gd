extends Area2D

# TODO i have no clue how to make this work if there are bodies other than the
# player's kinematicbody2d in the scene, worth investigating if we every
# have more than one body moving
func _on_Checkpoint_body_entered(_body:Node):
	$"../PlayerSpawner".set_spawn_position($SpawnPos.global_position)

extends Area2D

onready var pos: Vector2 = $CollisionShape2D/SpawnPos.global_position

# FIXME: this might get called once at the start of scene load because static
#  		 bodies will collide with checkpoints, but it shouldn't be too bad unless
# 		 a lot of checkpoints that contact the stage's static body exist
func _on_Checkpoint_body_entered(_body:Node):
	if _body.name == "PlayerBody":
		if PlayerSpawner.spawn_position == pos:
			return  # do nothing if this checkpoint is already active
		if self.visible:
			AudioPlayer.play_sound(AudioPlayer.CHECKPOINT)
		PlayerSpawner.set_spawn_position(pos)

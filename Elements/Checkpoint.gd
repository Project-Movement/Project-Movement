extends Area2D

onready var pos: Vector2 = $CollisionShape2D/SpawnPos.global_position
onready var particles: = $CollisionShape2D/TouchParticles
onready var active_particles: = $CollisionShape2D/ActiveParticles
onready var sprite: = $CollisionShape2D/Sprite
onready var original_modulate: Color = sprite.modulate

# FIXME: this might get called once at the start of scene load because static
#  		 bodies will collide with checkpoints, but it shouldn't be too bad unless
# 		 a lot of checkpoints that contact the stage's static body exist
func _on_Checkpoint_body_entered(_body:Node):
	if _body.name == "PlayerBody":
		if PlayerSpawner.spawn_position == pos:
			return  # do nothing if this checkpoint is already active
		if self.visible:
			AudioPlayer.play_sound(AudioPlayer.CHECKPOINT)
			Logger.log_level_action(Logger.ACTIONS.ENTER_CHECKPOINT, "")
			# one time particles
			particles.global_position = _body.global_position
			particles.restart()
			enable()
			var checkpoints = get_tree().get_nodes_in_group("Checkpoint")
			# print(checkpoints)
			for ckpt in checkpoints:
				if not ckpt == self:
					ckpt.disable()
		PlayerSpawner.set_spawn_position(pos)


# set if the visual effects of this checkpoint are enabled or not
func disable():
	sprite.modulate = original_modulate
	particles.emitting = false
	active_particles.emitting = false

func enable():
	sprite.modulate = Color(float(300)/255, float(300)/255, float(80)/255, float(171)/255)
	active_particles.restart()

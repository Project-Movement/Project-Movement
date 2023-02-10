extends Node


# onready var STEP: = preload("res://Sounds/footstep_carpet_001.ogg")
var STEP
# onready var JUMP: = preload("res://Sounds/impactPlank_medium_000.ogg")
onready var JUMP: = preload("res://Sounds/jump.wav")
onready var CHECKPOINT: = preload("res://Sounds/impactMining_003.ogg")
onready var DASH: = preload("res://Sounds/laserSmall_000.ogg")
onready var STOPWATCH_STOP: = preload("res://Sounds/toggle_001.ogg")
onready var STOPWATCH_START: = preload("res://Sounds/toggle_002.ogg")
onready var DIE: = preload("res://Sounds/die.wav")


onready var stream_players: = $StreamPlayers

func _ready():
	STEP = AudioStreamRandomPitch.new()
	STEP.audio_stream = preload("res://Sounds/footstep_concrete_000.ogg")


func play_sound(sound):
	for stream_player in stream_players.get_children():
		if not stream_player.playing:
			print(stream_player.name)
			stream_player.stream = sound
			stream_player.play()
			break

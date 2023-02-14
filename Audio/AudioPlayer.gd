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
onready var LANDING: = preload("res://Sounds/impactPlank_medium_004.ogg")
onready var SUPERJUMP: = preload("res://Sounds/laserLarge_001.ogg")
onready var WALLBOUNCE: = preload("res://Sounds/bounce.wav")


onready var sfx_players: = $SFXPlayers
onready var ui_sfx_players: = $UISFX

func _ready():
	STEP = AudioStreamRandomPitch.new()
	STEP.audio_stream = preload("res://Sounds/footstep_concrete_000.ogg")


func play_sound(sound):
	for stream_player in sfx_players.get_children():
		if not stream_player.playing:
			# print(stream_player.name)
			stream_player.stream = sound
			stream_player.play()
			break


# non-diegetic sounds, play to different channel
func play_ui_sound(sound):
	for stream_player in ui_sfx_players.get_children():
		if not stream_player.playing:
			# print(stream_player.name)
			stream_player.stream = sound
			stream_player.play()
			break
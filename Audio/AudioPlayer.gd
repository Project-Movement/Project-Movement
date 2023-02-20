extends Node

var enabled = true

# onready var STEP: = preload("res://Sounds/footstep_carpet_001.ogg")
var STEP
# onready var JUMP: = preload("res://Sounds/impactPlank_medium_000.ogg")
onready var JUMP: = preload("Sounds/jump.wav")
onready var CHECKPOINT: = preload("Sounds/impactMining_003.ogg")
onready var DASH: = preload("Sounds/laserSmall_000.ogg")
onready var STOPWATCH_STOP: = preload("Sounds/toggle_001.ogg")
onready var STOPWATCH_START: = preload("Sounds/toggle_002.ogg")
onready var DIE: = preload("Sounds/die.wav")
onready var LANDING: = preload("Sounds/impactPlank_medium_004.ogg")
onready var SUPERJUMP: = preload("Sounds/laserLarge_001.ogg")
onready var WALLBOUNCE: = preload("Sounds/bounce.wav")

onready var CLICK1: = preload("Sounds/click_001.ogg")
onready var CLICK2: = preload("Sounds/click_002.ogg")
onready var DROP1: = preload("Sounds/drop_001.ogg")
onready var DROP2: = preload("Sounds/drop_002.ogg")
onready var DROP3: = preload("Sounds/drop_003.ogg")
onready var DROP4: = preload("Sounds/drop_004.ogg")


onready var sfx_players: = $SFXPlayers
onready var ui_sfx_players: = $UISFX

func _ready():
	STEP = AudioStreamRandomPitch.new()
	STEP.audio_stream = preload("Sounds/footstep_concrete_000.ogg")


func play_sound(sound):
	if not enabled:
		return
	for stream_player in sfx_players.get_children():
		if not stream_player.playing:
			# print(stream_player.name)
			stream_player.stream = sound
			stream_player.play()
			break


# non-diegetic sounds, play to different channel
func play_ui_sound(sound):
	if not enabled:
		return
	for stream_player in ui_sfx_players.get_children():
		if not stream_player.playing:
			# print(stream_player.name)
			stream_player.stream = sound
			stream_player.play()
			break

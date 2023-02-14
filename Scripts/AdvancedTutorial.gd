extends Node2D


func _ready():
	Logger.log_level_start(Levels.TUTORIAL_ADVANCED, JSON.print({"time": Time.get_ticks_msec()}))

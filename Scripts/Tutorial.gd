extends Node2D


func _ready():
	Logger.log_level_start(Logger.LEVELS.TUTORIAL_BASIC, JSON.print({"time": Time.get_ticks_msec()}))

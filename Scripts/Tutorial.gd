extends Node2D


func _ready():
	Logger.log_level_start(Logger.LEVELS.TUTORIAL_BASIC, str(Logger.cur_time_millis()))

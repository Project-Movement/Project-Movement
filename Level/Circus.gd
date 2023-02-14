extends Node2D


func _ready():
	Logger.log_level_start(Logger.LEVELS.CIRCUS, str(Logger.cur_time_millis()))

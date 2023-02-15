extends Node2D


func _ready():
	Logger.log_level_start(Logger.LEVELS.LEVEL1, str(Logger.cur_time_millis()))


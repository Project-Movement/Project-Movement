extends Node2D


func _ready():
	Logger.log_level_start(Logger.LEVELS.STARTER, str(Logger.cur_time_millis()))


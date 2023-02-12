extends Node2D


func _ready():
	Logger.log_level_start(Logger.LEVELS.CIRCUS, JSON.print({"time": Time.get_ticks_msec()}))

extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	# Logger.start_new_session()
	# Logger.log_action_with_no_level(41, JSON.print({"gabba": "gook", "tenthy": 3}))
	Logger.log_level_start(Levels.TESTLEVEL, JSON.print({"time": Time.get_ticks_msec()}))

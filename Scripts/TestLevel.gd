extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	Logger.log_action_with_no_level(1, JSON.print({"gabba": "gook", "tenthy": 3}))

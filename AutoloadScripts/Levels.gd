extends Node


enum {
	TUTORIAL_BASIC = 900,
	TUTORIAL_ADVANCED = 901,
	TESTLEVEL = 902,
	TUTORIAL_ADVANCED2 = 903,
	LEVEL1 = 1,
	DEARYOU_WALLJUMP = 2,
	CIRCUS = 3,
	PILLARS = 20,
}

var levels_list: Array = [TUTORIAL_BASIC, TUTORIAL_ADVANCED2, DEARYOU_WALLJUMP, LEVEL1, CIRCUS, PILLARS]

onready var level_to_filename = {
	TUTORIAL_BASIC:     "res://Levels/Tutorial.tscn",
	TUTORIAL_ADVANCED:  "res://Levels/AdvancedTutorial.tscn",
	TUTORIAL_ADVANCED2: "res://Levels/AdvancedTutorial2.tscn",
	TESTLEVEL:          "res://Levels/TestLevel",
	LEVEL1:             "res://Levels/Level1.tscn",
	DEARYOU_WALLJUMP:   "res://Levels/DearYouWallJump.tscn",
	CIRCUS:             "res://Levels/Circus.tscn",
	PILLARS: 			"res://Levels/Pillars.tscn",
}

func get_scene_name(scene: int):
	return level_to_filename[scene]

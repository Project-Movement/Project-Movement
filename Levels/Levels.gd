extends Node


enum {
	TUTORIAL_BASIC = 900,
	TUTORIAL_ADVANCED = 901,
	TESTLEVEL = 902,
	TUTORIAL_ADVANCED2 = 903,
	LEVEL1 = 1,
	DEARYOU_WALLJUMP = 2,
	CIRCUS = 3,
}

onready var level_to_filename = {
    TUTORIAL_BASIC: "res://Scenes/Tutorial.tscn",
    TUTORIAL_ADVANCED: "res://Scenes/AdvancedTutorial.tscn",
    TUTORIAL_ADVANCED2: "res://Scenes/AdvancedTutorial2.tscn",
    TESTLEVEL: "res://Scenes/TestLevel",
    LEVEL1: "res://Scenes/Level1.tscn",
    DEARYOU_WALLJUMP: "res://Scenes/DearYouWallJump.tscn",
    CIRCUS: "res://Scenes/Circus.tscn",
}

func get_scene_name(scene: int):
    return level_to_filename[scene]
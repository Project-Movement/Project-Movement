extends Node2D


onready var jumptext = get_node("TextEdit")
onready var dashtext = get_node("TextEdit2")


func _ready():
	$TextEdit.set_text(str(Globals.max_airjumps))
	$TextEdit2.set_text(str(Globals.max_dashes))


func _on_TextEditAirJump_text_changed():
	print("set max jumps to " + jumptext.text)
	Globals.max_airjumps = int(jumptext.text)

func _on_TextEditDash_text_changed():
	print("set max dashes to " + dashtext.text)
	Globals.max_dashes = int(dashtext.text)


func _on_Back_pressed():
	SceneChanger.change_to_nonlevel("res://Scenes/TitleScreen.tscn")

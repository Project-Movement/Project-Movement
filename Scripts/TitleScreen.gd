extends Node2D

onready var scene = preload("res://Scenes/PlayerTest.tscn")

func _on_Button_pressed():
	var instance = scene.instance()
	get_parent().add_child(instance)
	queue_free()


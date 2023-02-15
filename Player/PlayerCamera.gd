extends Camera2D

export var max_dist: int = 1000

onready var player_body = get_parent()
onready var SCREEN_CENTER = get_viewport().size / 2
onready var mouse_offset_limit_x: int = SCREEN_CENTER.x
onready var mouse_offset_limit_y: int = SCREEN_CENTER.y

onready var HUD = get_parent().get_parent().get_node("HUD")

var lookaround_enabled = false


func _ready():
	var _a = get_viewport().connect("size_changed", self, "hande_viewport_size_change")


func _process(_delta):
	if Input.is_action_just_pressed("toggle_lookaround"):
		lookaround_enabled = not lookaround_enabled

		if not lookaround_enabled:
			self.position = Vector2.ZERO
			HUD.get_node("SpeedIndicator").visible = true
			HUD.get_node("AbilityIndicator").visible = true
			HUD.get_node("LookaroundIndicator").visible = false
		else:
			HUD.get_node("SpeedIndicator").visible = false
			HUD.get_node("AbilityIndicator").visible = false
			HUD.get_node("LookaroundIndicator").visible = true

	if lookaround_enabled:
		var diff = get_viewport().get_mouse_position() - SCREEN_CENTER
		var x_travel_prop = diff.x / mouse_offset_limit_x
		var y_travel_prop = diff.y / mouse_offset_limit_y

		self.position = max_dist * Vector2(x_travel_prop, y_travel_prop)



func handle_viewport_size_change():
	SCREEN_CENTER = get_viewport().size / 2

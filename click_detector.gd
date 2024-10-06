extends Area2D

@export var enabled: bool = true

signal nearby_click(target: Vector2)

func inhibit():
	#collision_layer = 0
	input_pickable = false
	enabled = false
func enable():
	collision_layer = 4
	input_pickable = true
	enabled = true
	
func _ready():
	if enabled:
		enable()
	else:
		inhibit()
	nearby_click.connect(debug_msg)

func debug_msg(target: Vector2):
	get_parent().identify("Targeting {0}".format([target]))

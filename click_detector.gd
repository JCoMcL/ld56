extends Area2D

@export var enabled: bool = true
@export var debug: bool = false

signal nearby_click(target: Vector2)
signal click()

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
	if debug:
		nearby_click.connect(debug_msg)

func debug_msg(target = null):
	print(self, ("nearby click at %s" % target if target else "clicked"))

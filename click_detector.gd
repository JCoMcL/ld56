extends Area2D

@export var enabled: bool = true
@export var debug: bool = false

signal nearby_click(where: Vector2, what: Area2D)
signal click()
signal interact()

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
		for sig in [nearby_click, click, interact]:
			sig.connect(debug_msg)

func debug_msg(where = null, what = null):
	print(self, ("nearby click at %s" % where if where else "clicked"))

extends Area2D

signal on_nearby_click(target: CharacterBody2D)

func inhibit():
	input_pickable = false
func enable():
	input_pickable = true
func _ready():
	collision_layer = 4
	on_nearby_click.connect(debug_msg)

func debug_msg(target: CharacterBody2D):
	get_parent().identify("Targeting {0}".format([target.label]))

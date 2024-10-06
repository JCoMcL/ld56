#@tool
extends Node2D
# Called when the node enters the scene tree for the first time.
func _process(delta: float) -> void:
	var gourt = child
	while true:
		if not gourt.sleeping:
			return
		if gourt.up_neighbour:
			gourt = gourt.up_neighbour
		else:
			break 
	get_tree().current_scene.restart()

var child
func _ready() -> void:
	var gourt = preload("res://guort.tscn")
	child = gourt.instantiate()
	add_child(child)
	get_viewport().get_camera_2d().set_tracking_target(child)
	child.label = "Bottom Guort"
	for i in range(6):
		var next = gourt.instantiate() 
		next.set_facing(randi_range(0, 1))
		next.label = "Gourt no. {0}".format([i])
		child.attach(next)

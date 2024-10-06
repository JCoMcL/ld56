#@tool
extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var gourt = preload("res://guort.tscn")
	var child = gourt.instantiate()
	add_child(child)
	child.label = "Bottom Guort"
	for i in range(6):
		var next = gourt.instantiate() 
		next.set_facing(randi_range(0, 1))
		next.label = "Gourt no. {0}".format([i])
		child.attach(next)

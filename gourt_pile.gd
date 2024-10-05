#@tool
extends Node2D

var gourts = [] 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var gourt = preload("res://gourt.tscn")
	for i in range(7):
		var child = gourt.instantiate()
		if gourts.size():
			gourts[-1].up_neighbour = child
			child.down_neighbour = gourts[-1]
		child.translate(Vector2(0, 110 * -i))
		child.z_index=i # Y sort y no work?
		add_child(child)
		gourts.append(child)
		
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

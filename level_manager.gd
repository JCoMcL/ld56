extends Node

@export var level: PackedScene

func _ready() -> void:
	add_child(level.instantiate())
	pass # Replace with function body.

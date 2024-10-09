extends Area2D

@export var whats_on_the_other_side: PackedScene

func enter_door():
	get_tree().current_scene.new_level(whats_on_the_other_side)

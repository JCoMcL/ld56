extends Area2D

@export var whats_on_the_other_side: PackedScene
func _ready() -> void:
	pass
	
func can_enter(body: Node2D) -> bool:
	return body in get_overlapping_bodies()
			
func enter():
	get_tree().current_scene.new_level(whats_on_the_other_side)

extends Node2D

var query = PhysicsPointQueryParameters2D.new()
func _ready() -> void:
	query.collide_with_areas = true
	query.collide_with_bodies = false
	query.collision_mask = 4

func collider_distance_from_pointer(o):
	return (o.collider.global_position - query.position).length_squared()
func compare_distance(a,b):
	return collider_distance_from_pointer(a) < collider_distance_from_pointer(b)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("poke"):
		query.position = get_global_mouse_position()
		var collision_objects = get_world_2d().direct_space_state.intersect_point(query)
		if not collision_objects.size():
			return
		
		collision_objects.sort_custom(compare_distance)
		var target = collision_objects.pop_front().collider.get_parent()
		for c in collision_objects:
			if c.collider.input_pickable:
				c.collider.on_nearby_click.emit(target)
				return

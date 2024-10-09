extends Area2D

# Helper function to get area bounds
func get_area_bounds(area: Area2D) -> Rect2:
	var collision_shape = area.get_node("CollisionShape2D")
	var shape = collision_shape.shape
	var global_pos = collision_shape.global_position
	
	if shape is RectangleShape2D:
		return Rect2(global_pos - shape.extents, shape.extents * 2)
	elif shape is CircleShape2D:
		var size = Vector2(shape.radius * 2, shape.radius * 2)
		return Rect2(global_pos - Vector2(shape.radius, shape.radius), size)

	return Rect2()

# Helper function to check if one rect is completely inside another
func is_completely_inside(inner: Rect2, outer: Rect2) -> bool:
	return (inner.position.x >= outer.position.x and
			inner.position.y >= outer.position.y and
			inner.end.x <= outer.end.x and
			inner.end.y <= outer.end.y)

func find_door():
	for d in get_overlapping_areas():
		return d

func can_enter_door(door: Area2D) -> bool:
	return is_completely_inside(get_area_bounds(self),get_area_bounds(door))
	

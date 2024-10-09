extends Area2D

func find_door():
	for d in get_overlapping_areas():
		return d

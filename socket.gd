extends Node2D

@export_range(0, 20, 0.1) var speed = 0.2 

signal done_flip
signal start_flip
var target_x
var flippin = false

func flip():
	position.x *= -1
	if not target_x:
		target_x = position.x 

func _ready() -> void:
	target_x = position.x

func flip_attached():
	var child = get_child(0)
	if child:
		child.flip(false)

func _process(delta: float) -> void:
	if position.x != target_x:
		if not flippin:
			flippin = true
			start_flip.emit()
		var displacement_to_target = target_x - position.x
		print(displacement_to_target)
		if displacement_to_target > -1.0:
			position.x = target_x
			done_flip.emit()
			flippin = false
		else:
			var increment = min(speed, displacement_to_target * speed) * delta
			print("moving by {0}".format([increment]))
			position.x += increment

extends Node2D

@export_range(0, 20, 0.1) var speed = 0.2 

signal done_flip
signal start_flip
var target_x
var flippin = false

func flip():
	if not target_x:
		position.x *= -1
	else:
		target_x *= -1
		

func _ready() -> void:
	target_x = position.x
	#done_flip.connect(flip_attached)
	start_flip.connect(flip_socket_of_attached)


func flip_attached():
	var child = get_child(0)
	if child:
		child.flip_self()

func flip_socket_of_attached():
	var child = get_child(0)
	if child:
		child.flip_socket()
	

func _process(delta: float) -> void:
	if position.x != target_x:
		if not flippin:
			flippin = true
			start_flip.emit()
		var displacement_to_target = target_x - position.x
		if abs(displacement_to_target) < 0.3:
			position.x = target_x
			done_flip.emit()
			flippin = false
		else:
			var increment = min(speed, displacement_to_target * speed) * delta
			position.x += increment
